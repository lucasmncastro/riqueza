class MovimentosController < ApplicationController
  
  before_filter :preenche_dados_basicos, :debug
  
  protected
    
    def debug
      puts params.inspect, '---------------------------------------'
    end
    
    def preenche_dados_basicos
      @data = Date.strptime(params[:data]) rescue Date.today
    end
  
  public
  
    def index
      registrados = Movimento.find_all_by_data @data
      agendados   = Movimento.find_all_agendados_by_data @data
      
      cumpridos_ou_nao = []
      
      agendados.each do |agendado|
        pais_dos_registrados = registrados.map {|m| m.pai}
        foi_cumprido = agendados.include? pais_dos_registrados.include? agendado
        # TODO
        
        cumpridos_ou_nao << (foi_cumprido ? agendado : agendado )
      end
      
      @movimentos = registrados
      @movimentos_agendados = cumpridos_ou_nao
    end
    
    def todos_do_mes
      @movimentos = Movimento.find_by_mes @data
      @movimentos_agendados = Movimento.find_all_agendados_by_data @data
    end
    
    def todos
      @movimentos = Movimento.find :all, :order => 'data'
    end

    def novo
      @movimento = Movimento.new :data => @data
      @movimento.tipo = 'Despesa'
    end
    
    def novo_filho
      @movimento = Movimento.find(params[:id]).gera_filho params[:data]
    end

    def edit
      @movimento = Movimento.find params[:id]
    end
    
    def find_by_tag
      @tag = params[:tag]
      @movimentos = Movimento.find_by_tag @tag
    end

    def update
      @movimento = Movimento.find params[:id]

      if @movimento.update_attributes params[:movimento]
        flash[:notice] = 'Movimento salvo com sucesso.'
        redirect_to :action => 'index', :data => @movimento.data
      else
        render :action => 'novo'
      end
    end

    def create
      @movimento = Movimento.new params[:movimento]

      if @movimento.save
        flash[:notice] = 'Movimento salvo com sucesso.'
        redirect_to :action => 'index', :data => @movimento.data
      else
        render :action => 'novo'      
      end
    end

    def destroy
      @movimento = Movimento.find params[:id]
      @movimento.destroy

      flash[:notice] = 'Movimento excluído com sucesso.'
      redirect_to :action => 'index', :data => @movimento.data
    end
    
end
