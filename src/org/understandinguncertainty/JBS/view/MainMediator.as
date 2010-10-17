package org.understandinguncertainty.JBS.view
{
	import org.robotlegs.mvcs.Mediator;
	import org.understandinguncertainty.JBS.model.AppModel;
	import org.understandinguncertainty.JBS.model.vo.WidthHeightMeasurement;
	import org.understandinguncertainty.JBS.signals.MainPanelMeasured;
	import org.understandinguncertainty.JBS.signals.ReleaseScreenSignal;
	import org.understandinguncertainty.JBS.signals.ScreenChangedSignal;
	import org.understandinguncertainty.JBS.signals.ScreenSelectorMeasured;
	
	public class MainMediator extends Mediator
	{
		public function MainMediator()
		{
			super();
		}
		
		[Inject]
		public var main:Main;
		
		[Inject]
		public var releaseScreenSignal:ReleaseScreenSignal;
		
		[Inject]
		public var screenChangedSignal:ScreenChangedSignal;
		
		[Inject]
		public var screenSelectorMeasured:ScreenSelectorMeasured;
		
		[Inject]
		public var mainPanelMeasured:MainPanelMeasured;
		
		[Inject]
		public var appModel:AppModel;
		
		override public function onRegister():void
		{
			releaseScreenSignal.add(releaseScreen);
			screenChangedSignal.add(screenChanged);
			
			screenSelectorMeasured.add(invalidateScreenSelector);
			mainPanelMeasured.add(invalidateMainPanel);
		}
		
		override public function onRemove():void
		{
			releaseScreenSignal.add(releaseScreen);
		}
		
		private function releaseScreen():void 
		{
			main.fullScreen.releaseScreen();
		}
		
		private function screenChanged(index:int):void
		{
			main.fullScreen.buttonEnabled = (index != 0);
		}
		
		private function invalidateScreenSelector(widthHeight:WidthHeightMeasurement):void
		{
			main.thumbnails.w_over_h = widthHeight.width/widthHeight.height;
			main.thumbnails.resize();
		}
		
		private function invalidateMainPanel(widthHeight:WidthHeightMeasurement):void
		{
			main.content.w_over_h = widthHeight.width/widthHeight.height; 
			main.content.resize();
		}

	}
}