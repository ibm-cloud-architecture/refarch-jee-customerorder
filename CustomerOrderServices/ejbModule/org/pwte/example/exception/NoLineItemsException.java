/**
 * 
 */
package org.pwte.example.exception;

/**
 * @author nrn
 *
 */
public class NoLineItemsException extends Exception {

	/**
	 * 
	 */
	private static final long serialVersionUID = -3162059688727892010L;

	/**
	 * 
	 */
	public NoLineItemsException() {
		// TODO Auto-generated constructor stub
	}

	/**
	 * @param message
	 */
	public NoLineItemsException(String message) {
		super(message);
		// TODO Auto-generated constructor stub
	}

	/**
	 * @param cause
	 */
	public NoLineItemsException(Throwable cause) {
		super(cause);
		// TODO Auto-generated constructor stub
	}

	/**
	 * @param message
	 * @param cause
	 */
	public NoLineItemsException(String message, Throwable cause) {
		super(message, cause);
		// TODO Auto-generated constructor stub
	}

}
