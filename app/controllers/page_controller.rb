class PageController < ApplicationController
  def whatis
  	@show_full_footer=true

  end

  def useragreement
  		@show_full_footer=true
  end

  def about
  	@show_full_footer=true
  end

  def privacypolicy
  	@show_full_footer=true
  end

  def cookiepolicy
  	@show_full_footer=true
  end
  
  def ahmad1
    render layout: 'header2'
  end

  def ahmad2
    render layout: 'header2'
  end

  def ahmad3
    render layout: 'header2'
  end
  def ahmad4
    render layout: 'header2'
  end
   def ahmad5
    render layout: 'header2'
  end
   def ahmad6
    render layout: 'header2'
  end
  
  def ahmad7
    
  end
      
end
