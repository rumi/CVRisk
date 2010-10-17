package org.understandinguncertainty.JBS.view
{
	import org.robotlegs.mvcs.Mediator;
	import org.understandinguncertainty.JBS.model.RunModel;
	import org.understandinguncertainty.JBS.signals.UpdateModelSignal;
	
	public class OutcomesMediator extends Mediator
	{
		
		[Inject]
		public var outcomes:Outcomes;
		
		[Inject]
		public var runModel:RunModel;
		
		[Inject]
		public var updateModelSignal:UpdateModelSignal;

		public function OutcomesMediator()
		{
			super();
		}
		
		override public function onRegister() : void
		{
			trace("outcomes register");
			outcomes.runModel = runModel;
			outcomes.updateModelSignal = updateModelSignal;
			outcomes.addListeners();
			updateModelSignal.dispatch();
		}
		
		override public function onRemove():void
		{
			trace("outcomes remove");
			outcomes.removeListeners();
		}
	}
}