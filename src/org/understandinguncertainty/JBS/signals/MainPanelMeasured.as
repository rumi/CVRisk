package org.understandinguncertainty.JBS.signals
{
	import org.osflash.signals.Signal;
	import org.understandinguncertainty.JBS.model.vo.WidthHeightMeasurement;
	
	public class MainPanelMeasured extends Signal
	{
		public function MainPanelMeasured()
		{
			super(WidthHeightMeasurement);
		}
	}
}