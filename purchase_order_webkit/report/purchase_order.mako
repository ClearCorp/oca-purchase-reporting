## -*- coding: utf-8 -*-
<html>
<head>
    <style type="text/css">
        ${css}

.list_main_table {
    border:thin solid #E3E4EA;
    text-align:center;
    border-collapse: collapse;
}
table.list_main_table {
    margin-top: 20px;
}
.list_main_headers {
    padding: 0;
}
.list_main_headers th {
    border: thin solid #000000;
    padding-right:3px;
    padding-left:3px;
    background-color: #EEEEEE;
    text-align:center;
    font-size:12;
    font-weight:bold;
}
.list_main_table td {
    padding-right:3px;
    padding-left:3px;
    padding-top:3px;
    padding-bottom:3px;
}
.list_main_lines,
.list_main_footers {
    padding: 0;
}
.list_main_footers {
    padding-top: 15px;
}
.list_main_lines td,
.list_main_footers td,
.list_main_footers th {
    border-style: none;
    text-align:left;
    font-size:12;
    padding:0;
}
.list_main_footers th {
    text-align:right;
}

td .total_empty_cell {
    width: 77%;
}
td .total_sum_cell {
    width: 13%;
}

.nobreak {
    page-break-inside: avoid;
}
caption.formatted_note {
    text-align:left;
    border-right:thin solid #EEEEEE;
    border-left:thin solid #EEEEEE;
    border-top:thin solid #EEEEEE;
    padding-left:10px;
    font-size:11;
    caption-side: bottom;
}
caption.formatted_note p {
    margin: 0;
}

.main_col1 {
    width: 40%;
}
td.main_col1 {
    text-align:left;
}
.main_col2,
.main_col3,
.main_col4,
.main_col6 {
    width: 10%;
}
.main_col5 {
    width: 7%;
}
td.main_col5 {
    text-align: center;
    font-style:italic;
    font-size: 10;
}
.main_col7 {
    width: 13%;
}

.list_bank_table {
    text-align:center;
    border-collapse: collapse;
    page-break-inside: avoid;
    display:table;
}

.act_as_row {
   display:table-row;
}
.list_bank_table .act_as_thead {
    background-color: #EEEEEE;
    text-align:left;
    font-size:12;
    font-weight:bold;
    padding-right:3px;
    padding-left:3px;
    white-space:nowrap;
    background-clip:border-box;
    display:table-cell;
}
.list_bank_table .act_as_cell {
    text-align:left;
    font-size:12;
    padding-right:3px;
    padding-left:3px;
    padding-top:3px;
    padding-bottom:3px;
    white-space:nowrap;
    display:table-cell;
}


.list_tax_table {
}
.list_tax_table td {
    text-align:left;
    font-size:12;
}
.list_tax_table th {
}
.list_tax_table thead {
    display:table-header-group;
}


.list_total_table {
    border:thin solid #E3E4EA;
    text-align:center;
    border-collapse: collapse;
}
.list_total_table td {
    border-top : thin solid #EEEEEE;
    text-align:left;
    font-size:12;
    padding-right:3px;
    padding-left:3px;
    padding-top:3px;
    padding-bottom:3px;
}
.list_total_table th {
    background-color: #EEEEEE;
    border: thin solid #000000;
    text-align:center;
    font-size:12;
    font-weight:bold;
    padding-right:3px
    padding-left:3px
}
.list_total_table thead {
    display:table-header-group;
}

.right_table {
    right: 4cm;
    width:"100%";
}

.std_text {
    font-size:12;
}

th.date {
    width: 90px;
}

td.amount, th.amount {
    text-align: right;
    white-space: nowrap;
}

td.date {
    white-space: nowrap;
    width: 90px;
}

td.vat {
    white-space: nowrap;
}
.address .recipient {
    font-size: 12px;
    margin-left: 350px;
    margin-right: 120px;
    float: right;
}

    </style>

</head>
<body>
    <%page expression_filter="entity"/>

    <%def name="address(partner, commercial_partner=None)">
        <%doc>
            XXX add a helper for address in report_webkit module as this won't be suported in v8.0
        </%doc>
        <% company_partner = False %>
        %if commercial_partner:
            %if commercial_partner.id != partner.id:
                <% company_partner = commercial_partner %>
            %endif
        %elif partner.parent_id:
            <% company_partner = partner.parent_id %>
        %endif

        %if company_partner:
            <tr><td class="name">${company_partner.name or ''}</td></tr>
            <tr><td>${partner.title and partner.title.name or ''} ${partner.name}</td></tr>
            <% address_lines = partner.contact_address.split("\n")[1:] %>
        %else:
            <tr><td class="name">${partner.title and partner.title.name or ''} ${partner.name}</td></tr>
            <% address_lines = partner.contact_address.split("\n") %>
        %endif
        %for part in address_lines:
            % if part:
                <tr><td>${part}</td></tr>
            % endif
        %endfor
    </%def>

    %for purch in objects :
        <%
              quotation = purch.state == 'draft'
        %>

        <% setLang(purch.partner_id.lang) %>
        <div class="address">
            <table class="recipient">
		        ${address(partner=purch.partner_id)}
            </table>

            %if purch.dest_address_id:
                <table class="shipping">
			        ${address(partner=purch.dest_address_id)}
                </table>
            %endif
        </div>

        <h1 style="clear:both; padding-top: 20px;">${quotation and _(u'Quotation N°') or _(u'Purchase Order N°') } ${purch.name}</h1>
        <p>${purch.note1 or '' | n}</p>
        <table class="basic_table" width="100%">
            <tr>
                <th>${_("Document")}</th>
                <th>${_("Your Order Reference")}</th>
                <th class="date">${_("Date Ordered")}</th>
                <th>${_("Validated by")}</th>
            </tr>
            <tr>
                <td>${purch.name}</td>
                <td>${purch.partner_ref or ''}</td>
                <td>${formatLang(purch.date_order, date=True)}</td>
                <td>${purch.validator and purch.validator.name or ''  }</td>
            </tr>
        </table>

        <table class="list_main_table" width="100%" >
            <thead>
                <tr>
	          <th class="list_main_headers" style="width: 100%">
	            <table style="width:100%">
	              <tr>
                    <th>${_("Description")}</th>
                    <th>${_("Taxes")}</th>
                    <th class="date">${_("Date Req.")}</th>
                    <th class="amount">${_("Qty")}</th>
                    <th class="amount">${_("Unit Price")}</th>
                    <th class="amount">${_("Net Price")}</th>
                  </tr>
                </table>
              </th>
                </tr>
            </thead>
            <tbody>
            %for line in purch.order_line :
          <tr>
            <td class="list_main_lines" style="width: 100%">
              <div class="nobreak">
                <table style="width:100%">
                  <tr>
                    <td>${line.name}</td>
                    <td>${ ', '.join([ tax.name or '' for tax in line.taxes_id ])}</td>
                    <td>${formatLang(line.date_order, date=True)}</td>
                    <td class="amount">${line.product_qty} ${line.product_uom.name}</td>
                    <td class="amount">${formatLang(line.price_unit, digits=get_digits(dp='Purchase Price'))}</td>
                    <td class="amount">${formatLang(line.price_subtotal, digits=get_digits(dp='Purchase Price'))} ${purch.pricelist_id.currency_id.symbol}</td>
                  </tr>
                 </table>
              </div>
            </td>
          </tr>
           %endfor
            </tbody>
	      <tfoot class="totals">
	        <tr>
	          <td class="list_main_footers" style="width: 100%">
	            <div class="nobreak">
	              <table style="width:100%">
	                <tr>
	                  <td class="total_empty_cell"/>
                  <th>
                    ${_("Net :")}
                  </th>
                  <td class="amount total_sum_cell">
                    ${formatLang(purch.amount_untaxed, digits=get_digits(dp='Purchase Price'))} ${purch.pricelist_id.currency_id.symbol}}
                  </td>
                </tr>
                <tr>
                  <td class="total_empty_cell"/>
                  <th>
                    ${_("Taxes:")}
                  </th>
                  <td class="amount total_sum_cell">
                    ${formatLang(purch.amount_tax, digits=get_digits(dp='Purchase Price'))} ${purch.pricelist_id.currency_id.symbol}
                  </td>
                </tr>
                <tr>
                  <td class="total_empty_cell"/>
                  <th>
                    ${_("Total:")}
                  </th>
                  <td class="amount total_sum_cell">
                    ${formatLang(purch.amount_total, digits=get_digits(dp='Purchase Price'))} ${purch.pricelist_id.currency_id.symbol}
                  </td>
                </tr>
              </table>
            </div>
          </td>
        </tr>
      </tfoot>
    </table>

	    <p>${purch.note2 or '' | n}</p>
        <p style="page-break-after:always"/>
        <br/>
	%endfor
</body>
</html>
