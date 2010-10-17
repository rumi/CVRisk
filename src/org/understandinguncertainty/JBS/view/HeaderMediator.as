package org.understandinguncertainty.JBS.view
{
	import org.robotlegs.mvcs.Mediator;
	import org.understandinguncertainty.JBS.model.ConfigProxy;
	
	public class HeaderMediator extends Mediator
	{
		[Inject]
		public var header:Header;
		
		[Inject]
		public var configProxy:ConfigProxy;
		
		public function HeaderMediator()
		{
			super();
		}
		
		override public function onRegister():void
		{
		}
	}
}