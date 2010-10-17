package org.understandinguncertainty.JBS.view
{
	import org.robotlegs.mvcs.Mediator;
	import org.understandinguncertainty.JBS.model.RunModel;
	import org.understandinguncertainty.JBS.signals.UpdateModelSignal;
	
	public class DeanfieldChartMediator extends Mediator
	{
		[Inject]
		public var outlookChart:DeanfieldChart;
		
		[Inject]
		public var runModel:RunModel;
		
		[Inject]
		public var updateModelSignal:UpdateModelSignal;
		
		public function DeanfieldChartMediator()
		{
			super();
		}
		
		override public function onRegister() : void
		{
			trace("DeanfieldChart register");
			outlookChart.runModel = runModel;
			outlookChart.updateModelSignal = updateModelSignal;
			outlookChart.addListeners();
			updateModelSignal.dispatch();
		}
		
		override public function onRemove():void
		{
			trace("DeanfieldChart remove");
			outlookChart.removeListeners();
		}
		
	}
}