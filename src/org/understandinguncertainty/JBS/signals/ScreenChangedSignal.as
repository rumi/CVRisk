package org.understandinguncertainty.JBS.signals
{
	import org.osflash.signals.Signal;
	
	public class ScreenChangedSignal extends Signal
	{
		public function ScreenChangedSignal()
		{
			super(int); // new screen index
		}
	}
}