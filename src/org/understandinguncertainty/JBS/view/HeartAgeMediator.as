package org.understandinguncertainty.JBS.view
{
	import org.robotlegs.mvcs.Mediator;
	import org.understandinguncertainty.JBS.model.RunModel;
	import org.understandinguncertainty.JBS.signals.UpdateModelSignal;
	
	public class HeartAgeMediator extends Mediator
	{
		[Inject]
		public var heartAge:HeartAge;
		
		[Inject]
		public var runModel:RunModel;
		
		[Inject]
		public var updateModelSignal:UpdateModelSignal;
		
		
		override public function onRegister() : void
		{
			trace("heartAge register");
			heartAge.runModel = runModel;
			heartAge.updateModelSignal = updateModelSignal;
			heartAge.addListeners();
			updateModelSignal.dispatch();
		}
		
		override public function onRemove():void
		{
			trace("heartAge remove");
			heartAge.removeListeners();
		}
		
	}
}