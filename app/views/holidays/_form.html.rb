<div class="columns"> 

  <div class="column left"> 

	<div class="group">
		<%= f.label :type_id, label_name('timetable'), :class => :label %>
		<%= f.select(:type_id, Type.timetable_type, {:selected => @timetable.type_id, :include_blank => false}) %><br />
		<span class="description"><%= label_name('timetable', 'description') %></span>
	</div>

	<div class="group">
		<%= f.label :starts_at, label_name('starts_at'), :class => :label %>
		<%= f.time_select :starts_at, :class => 'datetime_select' %><br />
		<span class="description"><%= label_name('starts_at', 'description') %></span>
	</div>

	<div class="group">
		<%= f.label :ends_at, label_name('ends_at'), :class => :label %>
		<%= f.time_select :ends_at, :class => 'datetime_select' %><br />
		<span class="description"><%= label_name('ends_at', 'description') %></span>
	</div>

	<div class="group">
		<%= f.label :timeframe, label_name('timeframe'), :class => :label %>
		<%= f.text_field :timeframe, :class => 'textscore' %><br />
		<span class="description"><%= label_name('timeframe', 'description') %></span>
	</div>

  </div> 

</div>
<%= f.hidden_field :installation_id %>

<div class="clear"></div> 

<div class="group navform">
	<%= submit_tag @timetable.new_record? ? control_label('create') : control_label('edit'), 
			:class => "button" %> <%= label_name(:or) %> <%= link_to label_name(:cancel), installation_path(:id => @installation.id) %>
</div>
