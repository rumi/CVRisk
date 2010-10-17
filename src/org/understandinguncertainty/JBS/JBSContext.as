package org.understandinguncertainty.JBS
{
	import flash.display.DisplayObjectContainer;
	
	import mx.resources.IResourceManager;
	import mx.resources.ResourceManager;
	
	import org.robotlegs.mvcs.SignalContext;
	import org.understandinguncertainty.JBS.controller.SetupInterventionProfile;
	import org.understandinguncertainty.JBS.model.AppModel;
	import org.understandinguncertainty.JBS.model.ConfigProxy;
	import org.understandinguncertainty.JBS.model.RunModel;
	import org.understandinguncertainty.JBS.model.UserModel;
	import org.understandinguncertainty.JBS.signals.ClearInterventionsSignal;
	import org.understandinguncertainty.JBS.signals.GotoScreen1Signal;
	import org.understandinguncertainty.JBS.signals.InterventionEditedSignal;
	import org.understandinguncertainty.JBS.signals.InterventionResetSignal;
	import org.understandinguncertainty.JBS.signals.MainPanelMeasured;
	import org.understandinguncertainty.JBS.signals.ModelChoiceChanged;
	import org.understandinguncertainty.JBS.signals.ModelUpdatedSignal;
	import org.understandinguncertainty.JBS.signals.ProfileCommitSignal;
	import org.understandinguncertainty.JBS.signals.ProfileLoadSignal;
	import org.understandinguncertainty.JBS.signals.ProfileSaveSignal;
	import org.understandinguncertainty.JBS.signals.ProfileValidSignal;
	import org.understandinguncertainty.JBS.signals.ReleaseScreenSignal;
	import org.understandinguncertainty.JBS.signals.ScreenChangedSignal;
	import org.understandinguncertainty.JBS.signals.ScreenSelectorMeasured;
	import org.understandinguncertainty.JBS.signals.UpdateModelSignal;
	import org.understandinguncertainty.JBS.view.AgeSettings;
	import org.understandinguncertainty.JBS.view.AgeSettingsMediator;
	import org.understandinguncertainty.JBS.view.Compare;
	import org.understandinguncertainty.JBS.view.CompareMediator;
	import org.understandinguncertainty.JBS.view.DeanfieldChart;
	import org.understandinguncertainty.JBS.view.DeanfieldChartMediator;
	import org.understandinguncertainty.JBS.view.Header;
	import org.understandinguncertainty.JBS.view.HeaderMediator;
	import org.understandinguncertainty.JBS.view.HeartAge;
	import org.understandinguncertainty.JBS.view.HeartAgeMediator;
	import org.understandinguncertainty.JBS.view.InterventionsPanel;
	import org.understandinguncertainty.JBS.view.InterventionsPanelMediator;
	import org.understandinguncertainty.JBS.view.Main;
	import org.understandinguncertainty.JBS.view.MainMediator;
	import org.understandinguncertainty.JBS.view.MainPanel;
	import org.understandinguncertainty.JBS.view.MainPanelMediator;
	import org.understandinguncertainty.JBS.view.Outcomes;
	import org.understandinguncertainty.JBS.view.OutcomesMediator;
	import org.understandinguncertainty.JBS.view.Profile;
	import org.understandinguncertainty.JBS.view.ProfileMediator;
	import org.understandinguncertainty.JBS.view.ScreenSelector;
	import org.understandinguncertainty.JBS.view.ScreenSelectorMediator;
	
	public class JBSContext extends SignalContext
	{
		
		public var includeQRisk:Boolean = false;
		
		public function JBSContext(contextView:DisplayObjectContainer=null, autoStartup:Boolean=true)
		{
			super(contextView, autoStartup);
		}
		
		override public function startup() : void
		{
			
			// inject ResourceManager
			injector.mapValue(IResourceManager, ResourceManager.getInstance());

			// QRisk?
			injector.mapValue(Boolean, includeQRisk, "includeQRisk");
			
			// Model
			injector.mapSingleton(ConfigProxy);
			
			var userProfile:UserModel = new UserModel();
			injector.mapValue(UserModel, userProfile, "userProfile");
			
			var interventionProfile:UserModel = new UserModel();
			injector.mapValue(UserModel, interventionProfile, "interventionProfile");	
			
			injector.mapSingleton(RunModel);
			injector.mapSingleton(AppModel);
			
			// Signals
			injector.mapSingleton(ProfileValidSignal);
			injector.mapSingleton(ProfileLoadSignal);
			injector.mapSingleton(ProfileSaveSignal);
			injector.mapSingleton(ProfileCommitSignal);
			injector.mapSingleton(GotoScreen1Signal);
			injector.mapSingleton(ReleaseScreenSignal);
			injector.mapSingleton(ScreenChangedSignal);
			injector.mapSingleton(ClearInterventionsSignal);
			injector.mapSingleton(MainPanelMeasured);
			injector.mapSingleton(ScreenSelectorMeasured);
			injector.mapSingleton(ModelChoiceChanged);
			
			injector.mapSingleton(InterventionEditedSignal);
			injector.mapSingleton(InterventionResetSignal);
			injector.mapSingleton(UpdateModelSignal);
			injector.mapSingleton(ModelUpdatedSignal);

			// View
			mediatorMap.mapView(Main, MainMediator);
			mediatorMap.mapView(Header, HeaderMediator);
			mediatorMap.mapView(MainPanel, MainPanelMediator);
			mediatorMap.mapView(ScreenSelector, ScreenSelectorMediator);
			mediatorMap.mapView(Profile, ProfileMediator);
			mediatorMap.mapView(InterventionsPanel, InterventionsPanelMediator);
			mediatorMap.mapView(HeartAge, HeartAgeMediator);
			mediatorMap.mapView(AgeSettings, AgeSettingsMediator);
//			mediatorMap.mapView(OutlookChart, OutlookChartMediator);
			mediatorMap.mapView(DeanfieldChart, DeanfieldChartMediator);
			mediatorMap.mapView(Outcomes, OutcomesMediator);
			mediatorMap.mapView(Compare, CompareMediator);
			
			signalCommandMap.mapSignalClass(GotoScreen1Signal, SetupInterventionProfile);
				
			// This will dispatch ContextEvent.STARTUP_COMPLETE
			super.startup();
		}
	}
}