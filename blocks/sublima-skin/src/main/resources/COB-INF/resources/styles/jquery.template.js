// Define the jQuery Template plugin. This takes a textarea
// value and converts it into an jQuery DOM elements (outside
// of the current DOM) and returns it. It takes only one
// argument: the name-value pairs of the values to replace
// into the template.
jQuery.fn.template = function( objValues ){

	// Get a reference to the current jQuery stack.
	var jThis = this;

	// Get the value of the textarea.
	var strHTML = jThis.val();

	// This will be our index variable for looping over the
	// values that were passed in.
	var strKey = "";

	// Check to make sure we have a value string. If this is
	// not the right kind of jQuery stack, the HTML string will
	// be null.
	if (strHTML){

		// Now that we have the proper value, we have to
		// replace in the mapped values. Loop over each
		// value that was passed in.
		for (strKey in objValues){

			// Escape all the special values in the key so that
			// it can be used in a regular expression.
			var strSafeKey = strKey.replace(
				new RegExp(
					"([\\[\\]\\.\\+\\*\\{\\}\\(\\)\\$\\?\\-])",
					"gi"
					),
				"\\$1"
				);

			// Replace the value.
			strHTML = strHTML.replace(
				new RegExp( "\\{" + strSafeKey + "\\}", "gi" ),
				objValues[ strKey ]
				);

		}

		// At this point, our HTML will have fully replaced
		// values. Now, let's convert it into a jQuery DOM
		// element and return it.
		return( jQuery( strHTML ) );

	} else {

		// Return empty jQuery stack.
		return( jQuery( [] ) );

	}
}