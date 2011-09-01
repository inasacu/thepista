<div class="block">

	<%#= get_secondary_navigation(@venue) %>

	<div class="content">  

		<h2 class="title">
			<%#= "#{control_action_label} #{label_name('for')} " %>
			<%= item_name_link(@installation) %>
		</h2>

		<div class="inner">
		
      <% form_for :timetable, :url => timetables_path, :html => { :class => :form } do |f| -%>
		<%= f.hidden_field :installation_id if @installation %>
        <%= render :partial => "form", :locals => {:f => f, :label_name => label_name(:create)} %>
      <% end -%>

		</div>

	</div>

</div>

