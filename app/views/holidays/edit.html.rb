<div class="block">
	
	<%= get_secondary_navigation(@venue) %>

	<div class="content">   

		<h2 class="title"><%= "#{control_action_label} #{h(@installation.name)} #{label_name(:in)} " %><%= item_name_link(@venue) %></h2>

		<div class="inner">
		
      <% form_for @timetable, :url => timetable_path(@timetable), :html => { :class => :form } do |f| -%>
        <%= render :partial => "form", :locals => {:f => f, :label_name => label_name(:create)} %>
      <% end -%>

		</div>

	</div>

</div>
