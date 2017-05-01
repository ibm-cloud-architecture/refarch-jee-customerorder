/**
 * 
 */
package org.pwte.example.exception;

/**
 * @author nrn
 *
 */
public class OrderNotOpenException extends Exception {

	/**
	 * 
	 */
	private static final long serialVersionUID = -6233880919327209994L;

	/**
	 * 
	 */
	public OrderNotOpenException() {
		// TODO Auto-generated constructor stub
	}

	/**
	 * @param message
	 */
	public OrderNotOpenException(String message) {
		super(message);
		// TODO Auto-generated constructor stub
	}

	/**
	 * @param cause
	 */
	public OrderNotOpenException(Throwable cause) {
		super(cause);
		// TODO Auto-generated constructor stub
	}

	/**
	 * @param message
	 * @param cause
	 */
	public OrderNotOpenException(String message, Throwable cause) {
		super(message, cause);
		// TODO Auto-generated constructor stub
	}

}
