package org.understandinguncertainty.JBS.model
{
	import mx.collections.ArrayCollection;
	import mx.resources.IResourceManager;
	
	import org.robotlegs.mvcs.Actor;
	import org.understandinguncertainty.JBS.framingham.model.FemaleParameters;
	import org.understandinguncertainty.JBS.framingham.model.FraminghamParameters;
	import org.understandinguncertainty.JBS.framingham.model.MaleParameters;
	import org.understandinguncertainty.JBS.model.vo.BetasVO;
	import org.understandinguncertainty.JBS.signals.ModelChoiceChanged;
	import org.understandinguncertainty.JBS.signals.ModelUpdatedSignal;
	import org.understandinguncertainty.JBS.signals.UpdateModelSignal;
	import org.understandinguncertainty.personal.VariableList;
	import org.understandinguncertainty.personal.types.BooleanPersonalVariable;

	[ResourceBundle("JBS")]
	public class RunModel extends Actor implements ICardioModel
	{
		
		public const mmolConvert:Number = 38.7;
		public var mmol:Boolean = true;
		
		[Inject]
		public var resourceManager:IResourceManager;

		[Inject(name="userProfile")]
		public var userProfile:UserModel;
		
		[Inject(name="interventionProfile")]
		public var interventionProfile:UserModel;
		
		[Inject]
		public var modelUpdatedSignal:ModelUpdatedSignal;
				
		/**
		 * if set, will cause a recalculation of the model before it is next used. 
		 */
		public var invalid:Boolean = true;
		
		public var selectedModel:String = "framingham";
		
		private var _interventionAge:int = 0;
		[Bindable]
		public function get interventionAge():int
		{
			return _interventionAge;
		}
		public function set interventionAge(age:int):void
		{
			_interventionAge = age;
			invalid = true;
		}
		
		private var _targetInterval:int = 10;
		[Bindable]
		public function get targetInterval():int
		{
			return _targetInterval;
		}
		public function set targetInterval(age:int):void
		{
			_targetInterval = age;
			invalid = true;
		}
		
		private var _minimumAge:int = 0;
		[Bindable]
		public function get minimumAge():int
		{
			return _minimumAge;
		}
		public function set minimumAge(age:int):void
		{
			_minimumAge = age;
			invalid = true;
		}
		
		private var _maximumAge:int = 0;
		[Bindable]
		public function get maximumAge():int
		{
			return _maximumAge;
		}
		public function set maximumAge(age:int):void
		{
			_maximumAge = age;
			invalid = true;
		}
		
		private var _maleParams:MaleParameters;
		private function get maleParameters():MaleParameters
		{
			return _maleParams || new MaleParameters();
		}
		
		private var _femaleParams:FemaleParameters;
		private function get femaleParameters():FemaleParameters
		{
			return _femaleParams || new FemaleParameters();
		}
		
		private function get framinghamParams():FraminghamParameters
		{
			return (gender == "male") ? maleParameters : femaleParameters;
		}
		
		public function get gender():String 
		{
			return userProfile.variableList.gender.toString();
		}
		
		public function get age():int {
			if(userProfile.variableList.dateOfBirth.getAge() == 0 || isNaN(userProfile.variableList.dateOfBirth.getAge()))
				trace("Break here");
				
			return userProfile.variableList.dateOfBirth.getAge();
		}
		
		private var _h:Number;
		[Bindable]
		public function get heartAge():Number
		{
			return _h;
		}
		public function set heartAge(i:Number):void
		{
			_h = i; 
			var hint:int = Math.floor(_h);
			var hmonth:int = Math.round((_h - hint)*12);
			heartAgeText = hint + " years"; /* + hmonth + " months"; */
		}
		
		[Bindable]
		public var heartAgeText:String = "";
		
		private var sum_e:Number = 0;
		private var sum_e_int:Number = 0;
		
		//private var g:Number = 0;
		public function get yearGain():Number {
			return (sum_e_int - sum_e)/100;
		}
		
		public function get meanAge():Number {
			return _minimumAge + sum_e_int/100;
		}
		
		public function commitProperties():void {
			_maximumAge = Math.min(100, framinghamParams.b.length-1);
			if(age == 0)
				return;
			_minimumAge = age;
			if(_interventionAge < _minimumAge)
				_interventionAge = _minimumAge;

			var series:Array= [];
			var series_star:Array= [];
			var series_deanfield:Array = [];

			var a:Number;
			var a_int:Number;
			var a_gp:Number
			var b:Number;
			var b_int:Number;
			var c:Number;
			var c_int:Number;
			var c_gp:Number;
			var d:Number;
			var d_int:Number;
			var d_gp:Number;
			var e:Number = 100;
			var e_int:Number = 100;
			var e_gp:Number = 100;
			var f:Number = 0;
			var f_int:Number = 0;
			var f_gp:Number = 0;
			var m:Number = 0;
			var m_int:Number = 0;
			var m_gp:Number = 0;
			var profile:VariableList = userProfile.variableList;
			var nonSmoker:Boolean = profile.nonSmoker.value as Boolean;
			var quitSmoker:Boolean = profile.quitSmoker.value as Boolean;
			var profile_int:VariableList = interventionProfile.variableList;
			var nonSmoker_int:Boolean = profile_int.nonSmoker.value as Boolean;
			var quitSmoker_int:Boolean = profile_int.quitSmoker.value as Boolean;

			sum_e = 0;
			sum_e_int = 0;
			
			// Push current age immediately
			series_deanfield.push({
				age:		age,
				green:		100,
				yellow:		100,
				red:		100,					
				
				yellowOnly:	100,
				redOnly:	100,
				
				fdash:		0, 
				fdash_int:	0,
				mdash:		0,
				mdash_int:	0,
				f_gp:		0
			});
			
			for(var i:int=age; i <= _maximumAge; i++) {
				
				var calculatedParams:CalculatedParams = calculateFramingham(i);
				
				a = calculatedParams.a;
				a_gp = calculatedParams.genPop_a;
				
				var b0:Number = framinghamParams.b[i];
				b = nonSmoker ? (quitSmoker ? 0.65*1.46*b0 : 0.88*b0) : 1.46*b0;
				if(i == age)
					heartAge = calculatedParams.h;
				if(i < interventionAge) {
					b_int = b;
					a_int = a;
				}
				else {
					a_int = calculatedParams.a_int;					
					b_int = nonSmoker_int ? (quitSmoker_int ? 0.65*1.46*b0 : 0.88*b0) : 1.46*b0;
				}
								
				c = e*b;
				c_int = e_int*b_int;
				c_gp = e_gp*b;
				
				d = e*a;
				d_int = e_int*a_int;
				d_gp = e_gp*a_gp;
				
				e -= (c+d);
				e_int -= (c_int+d_int);
				e_gp -= (c_gp + d_gp);
				sum_e_int += e_int;
				sum_e += e;
				
				f += d;
				f_int += d_int;
				f_gp += d_gp;
				
				m += c;
				m_int += c_int;
				m_gp += c_gp;
				
//				trac("age, ",i,",",a_int,",",b,",",c_int,",",d_int,",",e_int,",",f_int,",",m_int);
//				trac("int, ",i,",",a,",",b,",",c,",",d,",",e,",",f,",",m);
									
				// deanfield
				var yellow:Number = f+m - (m_int+f_int);
				var greenUnclamped:Number = 100 - Math.max(m + f, m_int + f_int);
				if(greenUnclamped < 0)
					yellow = Math.min(0, yellow + greenUnclamped);
				yellow = Math.max(0,yellow);
				
				var green:Number = Math.min(100, Math.max(0, greenUnclamped));
				var red:Number = f_int;
				
/*
				if(i==63) {
					trace("f = "+f);
					trace("f_int = "+f_int);
					trace("m = "+m);
					trace("m_int = "+m_int);
					trace("yellow = "+(f+m - (m_int+f_int)));
				}
*/				
				
				series_deanfield.push({
					age:		i+1,
					green:		green,
					yellow:		green + yellow,
					red:		green + yellow + red,					

					yellowOnly:	yellow,
					redOnly:	red,
					
					fdash:		f, 
					fdash_int:	f_int,
					mdash:		m,
					mdash_int:	m_int,
					f_gp:		f_gp
				});
				
 			}

			_seriesDeanfield = new ArrayCollection(series_deanfield);
			invalid = false;
			
			modelUpdatedSignal.dispatch();
		}
	
//		private var _series:ArrayCollection;
		private var _seriesDeanfield:ArrayCollection; // Inverted, green with no blue
		
		private function clamp(n:Number):Number 
		{
			return Math.max(0,Math.min(n, chanceClamp));
		}
		
		public var chanceClamp:Number = 100;
		
/*
		public function getOutlook():ArrayCollection
		{
			if(invalid)
				commitProperties();
			return _series;
		}
*/		
		public function getDeanfield():ArrayCollection
		{
			if(invalid)
				commitProperties();
			return _seriesDeanfield;	
		}
		
		private function calculateFramingham(i:int):CalculatedParams
		{
			
			var p:FraminghamParameters = framinghamParams;
			var beta:BetasVO = framinghamParams.beta;
			var q:BetasVO = framinghamParams.q;
			var profile:VariableList = userProfile.variableList;
			var profile_int:VariableList = interventionProfile.variableList;

			var ageBetaX:Number = Math.log(i) * beta.age;
			
			var tCBetaX:Number = Math.log(mmolConvert*(profile.totalCholesterol_mmol_L.value as Number)) * beta.totalCholesterol_mmol_L;
			var tCBetaX_1:Number = Math.log(mmolConvert*(profile_int.totalCholesterol_mmol_L.value as Number)) * beta.totalCholesterol_mmol_L;
			var tCBetaX_int:Number = (1-q.totalCholesterol_mmol_L)*tCBetaX + q.totalCholesterol_mmol_L*tCBetaX_1;
			
			var hdlBetaX:Number = Math.log(mmolConvert*(profile.hdlCholesterol_mmol_L.value as Number)) * beta.hdlCholesterol_mmol_L;
			var hdlBetaX_1:Number = Math.log(mmolConvert*(profile_int.hdlCholesterol_mmol_L.value as Number)) * beta.hdlCholesterol_mmol_L;
			var hdlBetaX_int:Number = (1-q.hdlCholesterol_mmol_L)*hdlBetaX + q.hdlCholesterol_mmol_L*hdlBetaX_1;

			// Note that the SBP may change AND/OR it may be treated during the intervention, so we calculate the effect before
			// and after taking both of these into account. Then we interpolate.
			var SBPTreated:Boolean = (profile.SBPTreated.value as Boolean);
			var sbpBetaX:Number = Math.log(profile.systolicBloodPressure.value as Number);
			if(SBPTreated)
				sbpBetaX *= beta.SBPTreated;
			else
				sbpBetaX *= beta.systolicBloodPressure;

			SBPTreated = (profile_int.SBPTreated.value as Boolean);
			var sbpBetaX_int:Number = Math.log(profile_int.systolicBloodPressure.value as Number);
			if(SBPTreated)
				sbpBetaX_int *= beta.SBPTreated;
			else
				sbpBetaX_int *= beta.systolicBloodPressure;
			
			// Now interpolate
			var smokerBetaX:Number = (profile.nonSmoker.value as Boolean) ? 0 : beta.smoker;
			var smokerBetaX_int:Number;
			if(profile_int.nonSmoker.value as Boolean) {
				smokerBetaX_int = (1 - q.smoker)*smokerBetaX;
			}
			else {
				smokerBetaX_int = (1 - q.smoker)*smokerBetaX + q.smoker*beta.smoker;
			}
			
			var diabeticBetaX:Number = (profile.diabetic.value as Boolean) ? beta.diabetic : 0;
			var diabeticBetaX_int:Number = (1 - q.diabetic)*diabeticBetaX
				+ ((profile_int.diabetic.value as Boolean) ? (q.diabetic * beta.diabetic) : 0);
			
			var sumBetaX:Number = ageBetaX + tCBetaX + hdlBetaX + sbpBetaX + smokerBetaX + diabeticBetaX;
			var sumBetaX_int:Number = ageBetaX + tCBetaX_int + hdlBetaX_int + sbpBetaX_int + smokerBetaX_int + diabeticBetaX_int;
			
			var lhr:Number = sumBetaX - p.averageHazard;
			var lhr_int:Number = sumBetaX_int - p.averageHazard;

			// heartAge
			var h:Number
			if(i == age)
				h = Math.exp(lhr/beta.age + p.xbar.age);

			//trace("fram age: "+i+" a: "+lhr);
			
			return new CalculatedParams(p.a * Math.exp(lhr), p.a*Math.exp(lhr_int), h, p.a*Math.exp(ageBetaX-p.xbar.age*p.beta.age));
		}

		private var _genPopProfile:VariableList;
		private function get genPopProfile():VariableList
		{
			if(_genPopProfile != null)
				return _genPopProfile;
			
			_genPopProfile = userProfile.variableList.clone();
			
			return _genPopProfile;
		}
		
	}
}
class CalculatedParams {
	public var a:Number;
	public var a_int:Number;
	public var genPop_a:Number
	public var h:Number;
	
	function CalculatedParams(a:Number, a_int:Number, h:Number, genPop_a:Number)
	{
		this.a = a;
		this.a_int = a_int;
		this.h = h;
		this.genPop_a = genPop_a;
	}
}