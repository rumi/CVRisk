package org.understandinguncertainty.personal.interfaces
{
	
	
	public interface IPersonalVariable
	{
		function get name():String;

		function get value():*;
		function set value(v:*):void;
		
		function get testValue():*;
		function set testValue(v:*):void;
		
		function fromString(s:String):void;
		function toString():String;
		
		function get type():String;
		
	}
}