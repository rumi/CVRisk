package org.understandinguncertainty.JBS.validators
{
	import mx.validators.DateValidator;
	import mx.validators.ValidationResult;
	
	public class DateOfBirthValidator extends DateValidator
	{
		
		public var isFramingham:Boolean = true;
		
		public function DateOfBirthValidator()
		{
			super();
		}
		
		override protected function doValidation(value:Object) : Array
		{
			var results:Array = super.doValidation(value);

			if (results.length > 0)
				return results;
			
			var yyyy:int = parseInt(value.year);
			var mm:int = parseInt(value.month) - 1;
			var dd:int = parseInt(value.day);
			
			var now:Date = new Date();
			
			if( (yyyy > now.fullYear - (isFramingham ? 10 : 30 ))
				|| (yyyy == now.fullYear && ( mm > now.month
					|| mm == now.month && dd > now.date))) {
				
				// Date is in the future
				results.push(new ValidationResult(
					true, "year", "futureDate",
					"too young to model risk"));
				return results;
			}
			
			if( yyyy + (isFramingham ? 100 : 84) < now.fullYear)  {
				
				// Patient is too old
				results.push(new ValidationResult(
					true, "year", "tooOld",
					"too old to model risk"));
				return results;
			}
			return results;
		}
	}
}