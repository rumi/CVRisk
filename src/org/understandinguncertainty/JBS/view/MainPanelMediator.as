package org.understandinguncertainty.JBS.view
{
	import org.robotlegs.mvcs.Mediator;
	import org.understandinguncertainty.JBS.model.ConfigProxy;
	import org.understandinguncertainty.JBS.signals.MainPanelMeasured;
	
	public class MainPanelMediator extends Mediator
	{
		[Inject]
		public var mainPanel:MainPanel;
		
		[Inject]
		public var configProxy:ConfigProxy;
		
		[Inject]
		public var mainPanelMeasured:MainPanelMeasured;
		
		public function MainPanelMediator()
		{
			super();
		}

		override public function onRegister():void
		{
			mainPanel.config = configProxy;
			mainPanel.mainPanelMeasured = mainPanelMeasured;
		}
		

	}
}