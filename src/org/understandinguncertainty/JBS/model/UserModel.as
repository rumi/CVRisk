package org.understandinguncertainty.JBS.model
{
	import org.robotlegs.mvcs.Actor;
	import org.understandinguncertainty.personal.PersonalisationFileStore;
	import org.understandinguncertainty.personal.VariableList;
	
	public class UserModel extends Actor
	{
		public var variableList:VariableList;
		public var personalData:PersonalisationFileStore;
		
		[Bindable]
		public var isValid:Boolean = true;

		public function UserModel()
		{
			variableList = new VariableList();
			personalData = new PersonalisationFileStore(variableList);

			super();
		}
	}
}