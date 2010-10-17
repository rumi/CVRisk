package org.understandinguncertainty.JBS.model
{
	import mx.collections.ArrayCollection;

	public interface ICardioModel
	{
		function get interventionAge():int;
		function set interventionAge(age:int):void;
		function get targetInterval():int;
		function set targetInterval(age:int):void;
		
		function get minimumAge():int;
		function set minimumAge(age:int):void;
		function get maximumAge():int;
		function set maximumAge(age:int):void;
		
		function getDeanfield():ArrayCollection;
		function get yearGain():Number;
		function get heartAge():Number;
	}
}