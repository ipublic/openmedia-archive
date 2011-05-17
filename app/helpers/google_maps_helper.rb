module GoogleMapsHelper  

  def initialize_gmap
    @gmap = Cartographer::Gmap.new('map')
    @gmap.center = current_site.ll  # center on muni coords by default 
    @gmap.zoom = 10
    
    # @gmap.zoom = :bound    
    @gmap.icons << Cartographer::Gicon.new  
    
    @gmap.controls << :type
    @gmap.controls << :large
    @gmap.controls << :scale
    @gmap.controls << :overview
    @gmap.debug = false 
    @gmap.marker_mgr = false
    @gmap.marker_clusterer = true
    
    cluster_icons = []

    org = Cartographer::ClusterIcon.new({:marker_type => "Organization"})
     org << {
                 :url => '/images/drop.gif',
                 :height => 73,
                  :width => 118,
                 :opt_anchor => [10, 0],
                 :opt_textColor => 'black'
               }
        #push second variant
     org << {
                 :url => '/images/drop.gif',
                 :height => 73,
                 :width => 118,
                 :opt_anchor => [20, 0],
                 :opt_textColor => 'black'
               }

       #push third variant
      org << {
                 :url => '/images/drop.gif',
                 :height => 73,
                 :width => 118,
                 :opt_anchor => [26, 0],
                 :opt_textColor => 'black'
             }
     cluster_icons << org

     @gmap.marker_clusterer_icons = cluster_icons
    return @gmap
  end
end