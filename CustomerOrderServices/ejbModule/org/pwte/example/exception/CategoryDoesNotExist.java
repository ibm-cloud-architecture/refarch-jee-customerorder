/**
 * 
 */
package org.pwte.example.exception;

/**
 * @author nrn
 *
 */
public class CategoryDoesNotExist extends RuntimeException {

	/**
	 * 
	 */
	private static final long serialVersionUID = -2384396576925376484L;

	/**
	 * 
	 */
	public CategoryDoesNotExist() {
		// TODO Auto-generated constructor stub
	}

	/**
	 * @param message
	 */
	public CategoryDoesNotExist(String message) {
		super(message);
		// TODO Auto-generated constructor stub
	}

	/**
	 * @param cause
	 */
	public CategoryDoesNotExist(Throwable cause) {
		super(cause);
		// TODO Auto-generated constructor stub
	}

	/**
	 * @param message
	 * @param cause
	 */
	public CategoryDoesNotExist(String message, Throwable cause) {
		super(message, cause);
		// TODO Auto-generated constructor stub
	}

}
