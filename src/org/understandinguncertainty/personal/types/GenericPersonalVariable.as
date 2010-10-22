package org.understandinguncertainty.personal.types
{
	import flash.utils.getQualifiedClassName;
	
	public class GenericPersonalVariable
	{
		//public var NAME:String;
		//protected var stringValue:String;
		
		private var _name:String;
				
		function GenericPersonalVariable(instanceName:String, defaultValue:*) {
			_name = instanceName;
			_value = defaultValue;
		}
		
		public function get name():String {
			return _name;
		}

		protected var _value:*;
		public function get value():* {
			return _value;
		}
		public function set value(v:*):void {
			_value = v;
		}
		
		protected var _testValue:*;
		public function get testValue():* {
			if(_testValue == null)
				_testValue = _value;
			return _testValue;
		}
		public function set testValue(v:*):void {
			_testValue = v;
		}
		
		public function resetTestValue():void {
			testValue = null;
		}
	}
}