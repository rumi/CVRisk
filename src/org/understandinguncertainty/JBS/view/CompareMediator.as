package org.understandinguncertainty.JBS.view
{
	import org.robotlegs.mvcs.Mediator;
	import org.understandinguncertainty.JBS.model.RunModel;
	import org.understandinguncertainty.JBS.signals.UpdateModelSignal;
	
	public class CompareMediator extends Mediator
	{
		[Inject]
		public var compare:Compare;
		
		[Inject]
		public var runModel:RunModel;
		
		[Inject]
		public var updateModelSignal:UpdateModelSignal;
		

		override public function onRegister() : void
		{
			trace("compare register");
			compare.runModel = runModel;
			compare.updateModelSignal = updateModelSignal;
			compare.addListeners();
			updateModelSignal.dispatch();
		}
		
		override public function onRemove():void
		{
			trace("compare remove");
			compare.removeListeners();
		}
		
		/*
		override public function onRegister():void
		{
			trace("compare register");
			//compare.runModel = runModel;
			//compare.updateModelSignal = updateModelSignal;
			//compare.addListeners();
		}

		override public function onRemove():void
		{
			trace("compare remove");
			compare.removeListeners();
		}
		*/
	}
}