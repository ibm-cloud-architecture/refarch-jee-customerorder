/**
 * 
 */
package org.pwte.example.exception;

/**
 * @author nrn
 *
 */
public class InvalidQuantityException extends Exception {

	/**
	 * 
	 */
	private static final long serialVersionUID = -747266767912834979L;

	/**
	 * 
	 */
	public InvalidQuantityException() {
		// TODO Auto-generated constructor stub
	}

	/**
	 * @param message
	 */
	public InvalidQuantityException(String message) {
		super(message);
		// TODO Auto-generated constructor stub
	}

	/**
	 * @param cause
	 */
	public InvalidQuantityException(Throwable cause) {
		super(cause);
		// TODO Auto-generated constructor stub
	}

	/**
	 * @param message
	 * @param cause
	 */
	public InvalidQuantityException(String message, Throwable cause) {
		super(message, cause);
		// TODO Auto-generated constructor stub
	}

}
