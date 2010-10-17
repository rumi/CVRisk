package org.understandinguncertainty.JBS.controller
{
	import org.understandinguncertainty.JBS.model.UserModel;
	import org.understandinguncertainty.JBS.signals.ClearInterventionsSignal;

	public class SetupInterventionProfile
	{

		[Inject(name="userProfile")]
		public var user:UserModel;
	
		[Inject(name="interventionProfile")]
		public var inter:UserModel;
		
		[Inject]
		public var clearInterventionsSignal:ClearInterventionsSignal;
		
		/**
		 * Reset the interventions model to be the same as the user model.
		 * Then update the interventions panel?
		 */
		public function execute():void
		{
			//trace("Moved from Profile Screen");
			inter.variableList = user.variableList.clone();
			
			clearInterventionsSignal.dispatch();
		}
	}
}