package org.pwte.example.domain;

import java.io.Serializable;
import java.math.BigDecimal;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.IdClass;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.PrePersist;
import javax.persistence.PreRemove;
import javax.persistence.PreUpdate;
import javax.persistence.PrimaryKeyJoinColumn;
import javax.persistence.Table;
import javax.persistence.Transient;
import javax.persistence.Version;

import org.codehaus.jackson.annotate.JsonIgnore;

@Entity
@Table(name="LINE_ITEM")
@IdClass(LineItemId.class)
public class LineItem implements Serializable {
	
	@Id
	@Column(name="ORDER_ID")
	private int orderId;
	
	@Id
	@Column(name="PRODUCT_ID")
	private int productId;
	protected long quantity;
	protected BigDecimal amount;
	
    @ManyToOne
    @PrimaryKeyJoinColumn(name="PRODUCT_ID",referencedColumnName="PRODUCT_ID")
	protected Product product;
    
    @ManyToOne
    @PrimaryKeyJoinColumn(name="ORDER_ID",referencedColumnName="ORDER_ID")
	protected Order order;
    
    @Transient
    
    private long version;
  
    
	public int getOrderId() {
		return orderId;
	}
	public void setOrderId(int orderId) {
		this.orderId = orderId;
	}
	public int getProductId() {
		return productId;
	}
	public void setProductId(int productId) {
		this.productId = productId;
	}
	public long getQuantity() {
		return quantity;
	}
	public void setQuantity(long quantity) {
		this.quantity = quantity;
	}
	public BigDecimal getAmount() {
		return amount;
	}
	public void setAmount(BigDecimal amount) {
		this.amount = amount;
	}
	public Product getProduct() {
		return product;
	}
	public void setProduct(Product product) {
		this.product = product;
	}
	
	@JsonIgnore
	public Order getOrder() {
		return order;
	}
	
	@JsonIgnore
	public void setOrder(Order order) {
		this.order = order;
	}
	
	@PrePersist void calculateTotalAdd()
	{
	   System.out.println("Adding new LI -> " + product.getName());
	   BigDecimal total = new BigDecimal(0);
	   if(getOrder() != null) total = getOrder().getTotal();
	   System.out.println("Old total " + total);
	   System.out.println("Adding new -> " + amount);
	   total = total.add(amount).setScale(2,BigDecimal.ROUND_HALF_UP);
	   System.out.println("Total in CallBack -> " + total);
	   order.setTotal(total);
	}
	

	@PreUpdate void recalculateTotal()
	{
	   System.out.println("PreUpdate -> " + product.getName());
	   BigDecimal  total = new BigDecimal(0);
	   if(getOrder().getLineitems().size() <= 0) return;
	   boolean inOrders = false;
	   for(LineItem item: getOrder().getLineitems())
	   {
	      if(item.equals(this)) inOrders = true;
	      System.out.println("recalc -> " + item.getAmount());
	      total = 
	        total.add(item.getAmount()).setScale(2,BigDecimal.ROUND_HALF_UP);
	   }
	   System.out.println("New Total recalc -> " + total);
	   if (inOrders)order.setTotal(total);	
	}
	
	@PreRemove void calculateTotalRemove()
	{
	   System.out.println("Removing LI -> " + product.getName());
	   BigDecimal total = getOrder().getTotal();
	   total = total.subtract(amount).setScale(2,BigDecimal.ROUND_HALF_UP);
	   order.setTotal(total);
	}
	
	@JsonIgnore
	public void setVersion(long version) {
		this.version = version;
	}
	
	@JsonIgnore
	public long getVersion() {
		return version;
	}


}
