package org.understandinguncertainty.JBS.view
{
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import mx.controls.Alert;
	import mx.core.FlexGlobals;
	
	import org.robotlegs.mvcs.Mediator;
	import org.understandinguncertainty.JBS.model.RunModel;
	import org.understandinguncertainty.JBS.model.UserModel;
	import org.understandinguncertainty.JBS.signals.GotoScreen1Signal;
	import org.understandinguncertainty.JBS.signals.ModelChoiceChanged;
	import org.understandinguncertainty.JBS.signals.ProfileCommitSignal;
	import org.understandinguncertainty.JBS.signals.ProfileLoadSignal;
	import org.understandinguncertainty.JBS.signals.ProfileSaveSignal;
	import org.understandinguncertainty.personal.PersonalisationFileStore;
	import org.understandinguncertainty.personal.VariableList;
	
	public class ProfileMediator extends Mediator
	{
		
		[Inject]
		public var profile:Profile;
		
		[Inject]
		public var profileLoadSignal:ProfileLoadSignal;
		
		[Inject]
		public var profileSaveSignal:ProfileSaveSignal;
		
		[Inject]
		public var profileCommitSignal:ProfileCommitSignal;
		
		[Inject]
		public var modelChoiceChanged:ModelChoiceChanged;
		
		[Inject]
		public var gotoScreen1Signal:GotoScreen1Signal;
		
		[Inject(name="userProfile")]
		public var userProfile:UserModel;		
		
		[Inject]
		public var runModel:RunModel;
		
		private var ps:PersonalisationFileStore;
		
		public function ProfileMediator()
		{
			super();
		}
		
		override public function onRegister():void
		{
			trace("Profile Register");
			ps = userProfile.personalData;
			profile.resized();
			addEventListeners();
			loadFromURL();
		}
		
		override public function onRemove():void
		{
			trace("Profile Remove");
			removeEventListeners();
		}
		
		private function addEventListeners():void {
			profileCommitSignal.add(nextScreen);
			profileLoadSignal.add(loadPersonalDetails);
			profileSaveSignal.add(savePersonalDetails);
			modelChoiceChanged.add(changeModel);
		}
		
		private function removeEventListeners():void {
			profileCommitSignal.remove(nextScreen);
			profileLoadSignal.remove(loadPersonalDetails);
			profileSaveSignal.remove(savePersonalDetails);
			modelChoiceChanged.remove(changeModel);
		}
		
		private function loadPersonalDetails(event:Event = null):void {
			ps.addEventListener(PersonalisationFileStore.DATAREADY, showPersonalData, false, 0, true);
			ps.load();
		}
		
		private function savePersonalDetails():void {
			setPersonalDetails();
			ps.save();
		}
		
		private function changeModel():void
		{
			trace("New model = " + profile.model.selectedValue);
			runModel.selectedModel = profile.model.selectedValue as String;
			profile.dateValidator.isFramingham = true;
		}
		
		//
		// populate the form with variable list data
		//
		private function showPersonalData(event:Event=null):void {
			var pvars:VariableList = ps.variableList;
			var dob:Date = pvars.dateOfBirth.value as Date;
			
			profile.yyyy.text = dob.fullYear.toString();
			profile.mm.text = (dob.month + 1).toString();
			profile.dd.text = dob.date.toString();
			profile.gender.selectedValue = pvars.gender.toString(); 
			profile.smoker.selected = !pvars.nonSmoker.value;
			profile.quitSmoker.selected = pvars.quitSmoker.value;
			//profile.fiveaday.selected = pvars.fiveaday.value;
			//profile.moderateAlcohol.selected = pvars.moderateAlcohol.value;
			profile.active.selected = pvars.active.value;
			profile.diabetic.selected = pvars.diabetic.value;
			
			profile.hdlCholesterol_mmol_L = Number(pvars.hdlCholesterol_mmol_L);
			profile.totalCholesterol_mmol_L = Number(pvars.totalCholesterol_mmol_L);
			
			profile.systolicBloodPressure = Number(pvars.systolicBloodPressure);
			profile.SBPTreated.selected = pvars.SBPTreated.value;
			
			profile.validate();
			
		}
		//
		// glean a variable list from the form data
		//
		private function setPersonalDetails():void {
			var pvars:VariableList = ps.variableList;
			pvars.dateOfBirth.fromString([profile.dd.text, profile.mm.text, profile.yyyy.text].join(":"));
			pvars.gender.fromString(profile.gender.selectedValue as String);
			pvars.nonSmoker.value = !profile.smoker.selected;
			pvars.quitSmoker.value = profile.quitSmoker.selected;
			//pvars.fiveaday.value = profile.fiveaday.selected;
			//pvars.moderateAlcohol.value = profile.moderateAlcohol.selected;
			pvars.active.value = profile.active.selected;
			pvars.diabetic.value = profile.diabetic.selected
			pvars.hdlCholesterol_mmol_L.value = profile.hdlCholesterol_mmol_L;
			pvars.totalCholesterol_mmol_L.value = profile.totalCholesterol_mmol_L;
			pvars.systolicBloodPressure.value = profile.systolicBloodPressure;
			pvars.SBPTreated.value = profile.SBPTreated.selected;
	
			
			userProfile.isValid = false;
		}
		
		//
		//---- View click events ----
		// 		
		private function nextScreen():void {
			trace("nextScreen");
			setPersonalDetails();			
			gotoScreen1Signal.dispatch();	
		}
		
		/*------- load from URL ----------*/
		public var configURL:String;
		
		private var loader:URLLoader;
		
		public function loadFromURL():void
		{
			// Acquire configURL from flashVar "config" 
			configURL = FlexGlobals.topLevelApplication.parameters.config;
			if(!configURL || configURL.match(/^\s*$/)) {
				showPersonalData(null);
				return;
			}
			
			//Alert.show("configURL = "+configURL);
			
			var request:URLRequest = new URLRequest(configURL);
			if(!loader) {
				loader = new URLLoader(request);
				addLoaderListeners();
			}
			try {
				loader.load(request);
			}
			catch(e:Error) {
				Alert.show(e.message, "Error opening "+configURL, Alert.OK);
			}
		}
		
		private function readLoader(event:Event):void
		{
			//trace(loader.data);
			var pvars:VariableList = ps.variableList;
			pvars.readXML(new XML(loader.data));
			showPersonalData();
		}
		
		private function addLoaderListeners():void {
			loader.addEventListener(Event.COMPLETE, readLoader, false, 0, true);
			loader.addEventListener(Event.OPEN, openHandler, false, 0, true);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler, false, 0, true);
			loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler, false, 0, true);
			loader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler, false, 0, true);
		}
		
		private function openHandler(event:Event):void {
			Alert.show(event.toString(), "Open");
		}
		
		private function securityErrorHandler(event:SecurityErrorEvent):void {
			Alert.show(event.toString(), "Network error");
		}
		
		private function httpStatusHandler(event:HTTPStatusEvent):void {
			Alert.show(event.toString(),"HTTP error");
		}
		
		private function ioErrorHandler(event:IOErrorEvent):void {
			Alert.show(event.toString(),"Network error");
		}
	}
}