package org.understandinguncertainty.JBS.signals
{
	import org.osflash.signals.Signal;
	import org.understandinguncertainty.JBS.model.vo.WidthHeightMeasurement;
	
	public class ScreenSelectorMeasured extends Signal
	{
		public function ScreenSelectorMeasured()
		{
			super(WidthHeightMeasurement);
		}
	}
}