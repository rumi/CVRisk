package org.understandinguncertainty.JBS.view
{
	import org.robotlegs.mvcs.Mediator;
	import org.understandinguncertainty.JBS.model.ConfigProxy;
	import org.understandinguncertainty.JBS.model.RunModel;
	import org.understandinguncertainty.JBS.model.UserModel;
	import org.understandinguncertainty.JBS.signals.ClearInterventionsSignal;
	import org.understandinguncertainty.JBS.signals.InterventionEditedSignal;
	import org.understandinguncertainty.JBS.signals.InterventionResetSignal;
	import org.understandinguncertainty.JBS.signals.UpdateModelSignal;
	import org.understandinguncertainty.personal.VariableList;
	import org.understandinguncertainty.personal.types.BooleanPersonalVariable;
	
	public class InterventionsPanelMediator extends Mediator
	{
		[Inject]
		public var configProxy:ConfigProxy;
		
		[Inject]
		public var interventionsPanel:InterventionsPanel;
		
		[Inject(name="userProfile")]
		public var userProfile:UserModel;
		
		[Inject(name="interventionProfile")]
		public var interventionProfile:UserModel;
		
		[Inject]
		public var runModel:RunModel;
		
		[Inject]
		public var clearInterventionsSignal:ClearInterventionsSignal;
		
		[Inject]
		public var interventionEditedSignal:InterventionEditedSignal;
		
		[Inject]
		public var interventionResetSignal:InterventionResetSignal;
		
		[Inject]
		public var updateModelSignal:UpdateModelSignal;
		
		public function InterventionsPanelMediator()
		{
			super();
		}
		
		override public function onRegister() : void
		{
			trace("Register Interventions");
//			interventionsPanel.outline = configProxy.sb2Stroke;
//			interventionsPanel.fill = configProxy.sb2Fill;
//			interventionsPanel.color = configProxy.sb2Color;
			
			clearInterventionsSignal.add(clearInterventions);
			interventionEditedSignal.add(commitIntervention);
			
			interventionsPanel.minAge = runModel.age;
			interventionsPanel.maxAge = runModel.maximumAge;
			
			// on registration is too late for the first screen switch since the
			// signal has already been sent
			clearInterventions();
		}
		
		override public function onRemove():void
		{
			trace("Remove Interventions");
			clearInterventionsSignal.remove(clearInterventions);
			interventionEditedSignal.remove(commitIntervention);
		}
		
		private function clearInterventions():void
		{
			
			trace("clear Interventions");
			setInterventions(userProfile.variableList);
			/*
			interventionsPanel.minAge = runModel.age;
			interventionsPanel.maxAge = runModel.maximumAge;
			
			var user:VariableList = userProfile.variableList;
			
			interventionsPanel.sbp.original = user.systolicBloodPressure.value as Number;
			interventionsPanel.sbp_treatedCheck.original = user.SBPTreated.value as Boolean;
			
			var conversion:Number = runModel.mmol ? 1 : runModel.mmolConvert;
			interventionsPanel.tc.original = (user.totalCholesterol_mmol_L.value as Number)*conversion;
			interventionsPanel.hdlc.original = (user.hdlCholesterol_mmol_L.value as Number)*conversion;
			trace("clear hdlc="+interventionsPanel.hdlc.original);
			interventionsPanel.tc.sigma = 1*conversion;
			interventionsPanel.hdlc.sigma = 0.4*conversion ;
			
			interventionsPanel.smokerCheck.original = user.nonSmoker.value as Boolean;
			interventionsPanel.exerciseCheck.original = user.active.value as Boolean;
			
			interventionsPanel.update();
			updateModelSignal.dispatch();
			*/
		}
		
		private function setIntervention():void
		{
			trace("set Interventions");
			setInterventions(interventionProfile.variableList);
		}
		
		private function setInterventions(user:VariableList):void
		{
			interventionsPanel.minAge = runModel.age;
			interventionsPanel.maxAge = runModel.maximumAge;
			
			interventionsPanel.sbp.original = user.systolicBloodPressure.value as Number;
			interventionsPanel.sbp_treatedCheck.original = user.SBPTreated.value as Boolean;
			
			var conversion:Number = runModel.mmol ? 1 : runModel.mmolConvert;
			interventionsPanel.tc.original = (user.totalCholesterol_mmol_L.value as Number)*conversion;
			interventionsPanel.hdlc.original = (user.hdlCholesterol_mmol_L.value as Number)*conversion;
			interventionsPanel.tc.sigma = 1*conversion;
			interventionsPanel.hdlc.sigma = 0.4*conversion ;
			
			interventionsPanel.smokerCheck.original = user.nonSmoker.value as Boolean;
			interventionsPanel.exerciseCheck.original = user.active.value as Boolean;
			
			interventionsPanel.update();
			updateModelSignal.dispatch();
		}
		
		private function commitIntervention(interventionId:String):void
		{
			//trace("commit? ", interventionsPanel[interventionId] is InterventionCheck);
			var inter:VariableList = interventionProfile.variableList;
			
			var check:InterventionCheck = interventionsPanel[interventionId] as InterventionCheck;
			if(check) {
				switch(interventionId) {
					
					case "sbp_treatedCheck":
						inter.SBPTreated.value = check.selected;
						if(check.selected) {
							// started intervention so we need to set SBP to target level
							if((inter.systolicBloodPressure.value as Number) > 140) {
								inter.systolicBloodPressure.value = 140;
								interventionsPanel.sbp.value = 140;
							}
						}
						break;
					
					case "smokerCheck":
						inter.nonSmoker.value = check.selected;
						break;
					
					case "exerciseCheck":
						inter.active.value = check.selected;
						break;
				}
			}

			var conversion:Number = runModel.mmol ? 1 : 1/runModel.mmolConvert;
			var stepper:InterventionStepper = interventionsPanel[interventionId] as InterventionStepper;
			if(stepper) {
				switch(interventionId) {
					
					case "sbp":
						inter.systolicBloodPressure.value = stepper.value;
						break;
					
					case "tc":
						inter.totalCholesterol_mmol_L.value = stepper.value * conversion;
						break;
					
					case "hdlc":
						inter.hdlCholesterol_mmol_L.value = stepper.value * conversion;
						trace("commit hdlc="+inter.hdlCholesterol_mmol_L.value);
						break;
					
					case "weight":
						inter.weight_kg.value = stepper.value;
				}
			}
			
			updateModelSignal.dispatch();
		}
		
		private function resetIntervention(interventionId:String):void
		{
			//trace("reset? ", interventionsPanel[interventionId] is InterventionCheck);
			var inter:VariableList = interventionProfile.variableList;
			var user:VariableList = userProfile.variableList;
			
			var check:InterventionCheck = interventionsPanel[interventionId] as InterventionCheck;
			if(check) {
				switch(interventionId) {
					
					case "sbp_treatedCheck":
						check.selected = (inter.SBPTreated.value = user.SBPTreated.value) as Boolean;
						break;
					
					case "nonSmoker":
						check.selected = (inter.nonSmoker.value = user.nonSmoker.value) as Boolean;
						break;
					
					case "exerciseCheck":
						check.selected = (inter.active.value = user.active.value) as Boolean;
						break;
				}
			}

			var conversion:Number = runModel.mmol ? 1 : runModel.mmolConvert;
			var stepper:InterventionStepper = interventionsPanel[interventionId] as InterventionStepper;
			if(stepper) {
				switch(interventionId) {
					
					case "sbp":
						stepper.value = (inter.systolicBloodPressure.value = user.systolicBloodPressure.value) as Number;
						break;
					
					case "tc":
						stepper.value = (inter.totalCholesterol_mmol_L.value = user.totalCholesterol_mmol_L.value) as Number;
						stepper.value *= conversion;
						break;
					
					case "hdlc":
						stepper.value = (inter.hdlCholesterol_mmol_L.value = user.hdlCholesterol_mmol_L.value) as Number;
						stepper.value *= conversion;
						trace("reset hdlc="+inter.hdlCholesterol_mmol_L.value);
						break;
					
					case "weight":
						stepper.value = (inter.weight_kg.value = user.weight_kg.value) as Number;
						break;
				}
			}
			
			updateModelSignal.dispatch();
		}
		
		
	}
}