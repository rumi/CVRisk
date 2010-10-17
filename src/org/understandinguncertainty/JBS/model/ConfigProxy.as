package org.understandinguncertainty.JBS.model
{
	import mx.graphics.SolidColor;
	import mx.graphics.SolidColorStroke;
	
	import org.robotlegs.mvcs.Actor;
	
	public class ConfigProxy extends Actor
	{
		public function ConfigProxy()
		{
			super();
		}
		
		public var xml:XML = <config>
				<title>Cardiovascular Risk Assessment</title>
			</config>;
		
		public function get title():String
		{
			return xml.title[0].toString();
		}
		
		[Bindable]
		public var mainFill:SolidColor = new SolidColor(0xffffff, 1);
		
		[Bindable]
		public var mainStroke:SolidColorStroke = new SolidColorStroke(0, 2, 0.4);
		
		[Bindable]
		public var mainRadius:int = 10;
		
		[Bindable]
		public var sb2Color:uint = 0;
		
		[Bindable]
		public var sb2Fill:SolidColor = new SolidColor(0xffffff, 1);
		
		[Bindable]
		public var sb2Stroke:SolidColorStroke = new SolidColorStroke(0, 2, 0.4);
		
		[Bindable]
		public var sb2Radius:int = 10;
	}
}