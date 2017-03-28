/**
 * 
 */
package org.pwte.example.exception;

/**
 * @author nrn
 *
 */
public class OrderAlreadyOpenException extends RuntimeException {

	/**
	 * 
	 */
	private static final long serialVersionUID = -8610794306148655383L;

	/**
	 * 
	 */
	public OrderAlreadyOpenException() {
		// TODO Auto-generated constructor stub
	}

	/**
	 * @param message
	 */
	public OrderAlreadyOpenException(String message) {
		super(message);
		// TODO Auto-generated constructor stub
	}

	/**
	 * @param cause
	 */
	public OrderAlreadyOpenException(Throwable cause) {
		super(cause);
		// TODO Auto-generated constructor stub
	}

	/**
	 * @param message
	 * @param cause
	 */
	public OrderAlreadyOpenException(String message, Throwable cause) {
		super(message, cause);
		// TODO Auto-generated constructor stub
	}

}
