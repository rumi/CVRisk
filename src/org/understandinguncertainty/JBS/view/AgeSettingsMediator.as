package org.understandinguncertainty.JBS.view
{
	import org.robotlegs.mvcs.Mediator;
	import org.understandinguncertainty.JBS.model.RunModel;
	
	public class AgeSettingsMediator extends Mediator
	{
		[Inject]
		public var ageSettings:AgeSettings;
		
		[Inject]
		public var runModel:RunModel;
		
/*		[Inject]
		public var clearInterventionsSignal:ClearInterventionsSignal;
		
		[Inject]
		public var interventionEditedSignal:InterventionEditedSignal;
		
		[Inject]
		public var interventionResetSignal:InterventionResetSignal;
		
		[Inject]
		public var updateModelSignal:UpdateModelSignal;
*/		

		
		public function AgeSettingsMediator()
		{
			super();
		}
		
		override public function onRegister():void 
		{
			ageSettings.minAge = runModel.age;
			ageSettings.maxAge = runModel.maximumAge;
			ageSettings.targetInterval.value = 10;
			ageSettings.targetInterval.maximum = runModel.maximumAge - runModel.age;
			
			// on registration is too late for the first screen switch since the
			// signal has already been sent
			reset();
		}
		
		public function reset():void
		{
			ageSettings.minAge = runModel.age;
			ageSettings.maxAge = runModel.maximumAge;
			ageSettings.interventionAgeStepper.value = runModel.interventionAge;
			ageSettings.targetInterval.value = runModel.targetInterval;
		}
	}
}