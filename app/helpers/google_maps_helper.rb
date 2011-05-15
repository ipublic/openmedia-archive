module GoogleMapsHelper  

  def initialize_map
    @map = Cartographer::Gmap.new('map')    
    @map.zoom = :bound    
    @map.icons << Cartographer::Gicon.new  
    
    @map.controls << :type
    @map.controls << :large
    @map.controls << :scale
    @map.controls << :overview
    @map.debug = false 
    @map.marker_mgr = false
    @map.marker_clusterer = true
    
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

     @map.marker_clusterer_icons = cluster_icons
    return @map
  end
end