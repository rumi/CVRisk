package org.understandinguncertainty.JBS.view
{
	import org.robotlegs.mvcs.Mediator;
	import org.understandinguncertainty.JBS.model.AppModel;
	import org.understandinguncertainty.JBS.signals.GotoScreen1Signal;
	import org.understandinguncertainty.JBS.signals.ProfileValidSignal;
	
	public class ScreenSelectorMediator extends Mediator
	{
		public function ScreenSelectorMediator()
		{
			super();
		}
		
		[Inject]
		public var gotoScreen1Signal:GotoScreen1Signal;
		
		[Inject]
		public var screenSelector:ScreenSelector;
		
		[Inject]
		public var appModel:AppModel;
		
		override public function onRegister() : void
		{
			screenSelector.addListeners();
			gotoScreen1Signal.add(gotoScreen1);
		}
		
		override public function onRemove() : void
		{
			screenSelector.removeListeners();
		}
		
		[Bindable]
		public function get selectedScreen():int
		{
			return screenSelector.selectedScreen;
		}
		public function set selectedScreen(index:int):void
		{
			screenSelector.selectedScreen = index;
			appModel.screenIndex = index;
		}
		
		private function gotoScreen1():void
		{
			screenSelector.gotoScreen1();
			appModel.screenIndex = 1;
		}
	}
}