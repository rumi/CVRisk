package org.understandinguncertainty.personal
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.FileReference;
	import flash.utils.*;
	
	import mx.controls.Alert;
	
	import org.understandinguncertainty.personal.interfaces.IPersonalVariable;
	import org.understandinguncertainty.personal.interfaces.IPersonalisationStore;
	
	public class PersonalisationFileStore extends EventDispatcher implements IPersonalisationStore
	{
		private var _variableList:VariableList;
		
		private var loadFile:FileReference = new FileReference();
		private var saveFile:FileReference = new FileReference();
		
		public static const DATAREADY:String = "dataReady";
		
		public function PersonalisationFileStore(vList:VariableList) {
			
			_variableList = vList;
		}
		
		[Deprecated(replacement='variableList')]
		public function get variable():VariableList {
			return variableList;
		}
		
		public function get variableList():VariableList {
			return _variableList;
		}

		/**
		 * 
		 * @return a clone of the PersonalisationFileStore variableList which can safely store the 
		 * variables even when the store is deleted.
		 * 
		 */
/*		public function get cloneVariableList():VariableList {
			return variableList.clone();
		}
*/
		private var inProgress:Boolean = false;
		
		/**
		 * Load the store from a file
		 */
		public function load():void {
			if(inProgress) return;
			inProgress = true;
			var f:FileReference = loadFile;
			f.addEventListener(Event.SELECT, loadFileSelected);
			f.browse();
		}
		
		private function loadFileSelected(event:Event):void {
			var f:FileReference = event.target as FileReference;
			f.addEventListener(Event.CANCEL, loadFileCancelled);
			f.addEventListener(Event.COMPLETE, loadFileCompleted);
			f.addEventListener(flash.events.IOErrorEvent.IO_ERROR, loadError);
			f.load();
		}
		
		private function loadFileCancelled(event:Event):void { 
			var f:FileReference = event.target as FileReference;
			inProgress = false;
		}
		
		private function loadFileCompleted(event:Event):void {
			var f:FileReference = event.target as FileReference;
			var s:String = f.data.toString(); 
			var filedata:XML = new XML(s);
						
			variableList.readXML(filedata);
			
			dispatchEvent(new Event(DATAREADY));
			inProgress = false;
		}
		
		private function loadError(event:Event):void {
			trace("loadError");
			inProgress = false;
		}
		
		/**
		 * Save the store to persistent memory
		 */
		public function save():void {
			if(inProgress) return;
			inProgress = true;
			var f:FileReference = saveFile;
			f.addEventListener(Event.CANCEL, saveFileCancelled);
			f.addEventListener(Event.COMPLETE, saveFileCompleted);
			f.addEventListener(flash.events.IOErrorEvent.IO_ERROR, saveError);
			f.save(variableList.writeXML(), "personaldata.xml");
		}
		
		public function saveFileCancelled(event:Event):void {
			var f:FileReference = event.target as FileReference;
			inProgress = false;
		}
		
		private function saveFileCompleted(event:Event):void {
			var f:FileReference = event.target as FileReference;
			inProgress = false;
		}

		private function saveError(event:Event):void {
			trace("saveError");
			inProgress = false;
		}		
		
		/**
		 * Empty this personalisation store
		 */
		public function clear():void {
			_variableList = new VariableList();
		}
		
		/**
		 * return a reference to a personalisation variable
		 */
		public function  getVariable(instanceName:String):IPersonalVariable {
			return variableList.getVariable(instanceName);
		}
	}
}