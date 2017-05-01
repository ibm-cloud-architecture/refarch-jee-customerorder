/**
 * 
 */
package org.pwte.example.exception;

/**
 * @author nrn
 *
 */
public class CustomerDoesNotExistException extends Exception {

	/**
	 * 
	 */
	private static final long serialVersionUID = 8840757878297468020L;

	/**
	 * 
	 */
	public CustomerDoesNotExistException() {
		// TODO Auto-generated constructor stub
	}

	/**
	 * @param message
	 */
	public CustomerDoesNotExistException(String message) {
		super(message);
		// TODO Auto-generated constructor stub
	}

	/**
	 * @param cause
	 */
	public CustomerDoesNotExistException(Throwable cause) {
		super(cause);
		// TODO Auto-generated constructor stub
	}

	/**
	 * @param message
	 * @param cause
	 */
	public CustomerDoesNotExistException(String message, Throwable cause) {
		super(message, cause);
		// TODO Auto-generated constructor stub
	}

}
