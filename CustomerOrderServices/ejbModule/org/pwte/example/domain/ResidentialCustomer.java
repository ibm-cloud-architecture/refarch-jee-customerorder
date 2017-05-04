package org.pwte.example.domain;

import java.io.Serializable;

import javax.persistence.Basic;
import javax.persistence.Column;
import javax.persistence.DiscriminatorValue;
import javax.persistence.Entity;

@Entity
@DiscriminatorValue("RESIDENTIAL")
public class ResidentialCustomer extends AbstractCustomer implements Serializable {

	private static final long serialVersionUID = -6734139231865273295L;

	public ResidentialCustomer() {
		
	}

	@Column(name = "RESIDENTIAL_HOUSEHOLD_SIZE")
	protected short householdSize;

	@Column(name = "RESIDENTIAL_FREQUENT_CUSTOMER")
	@Basic
	protected boolean frequentCustomer;

	public short getHouseholdSize() {
		return householdSize;
	}

	public void setHouseholdSize(short householdSize) {
		this.householdSize = householdSize;
	}

	public boolean isFrequentCustomer() {
		return frequentCustomer;
	}

	public void setFrequentCustomer(boolean frequentCustomer) {
		this.frequentCustomer = frequentCustomer;
	}

}
