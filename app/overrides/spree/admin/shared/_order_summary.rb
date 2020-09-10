Deface::Override.new(
    virtual_path: 'spree/admin/shared/_order_summary',
    name: 'display_affiliate_commission',
    insert_after: 'td[id="item_total"]',
    text: <<-HTML
            <tr>
              <td data-hook='admin_order_tab_affiliate_commission'>
                <strong>Affiliate Commission:</strong>
              </td>
              <td id='order_commission'>
                <% if @order.transactions.present? %>
                    <% @order.transactions.each do |affiliate_commission| %>
                        <%= affiliate_commission.affiliate.name %> - <%= Spree::Money.new(affiliate_commission.amount, {currency: @order.currency}) %> <br/>
                    <% end %>
                <% else %>
                    <%= Spree::Money.new(@order.transactions.pluck(:amount), {currency: @order.currency}) %>
                <% end %>
              </td>
          </tr>
    HTML
)
