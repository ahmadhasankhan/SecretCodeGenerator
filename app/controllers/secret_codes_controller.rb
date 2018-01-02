class SecretCodesController < ApplicationController
  before_action :set_secret_code, only: [:destroy]
  before_action :authenticate_user!
  load_and_authorize_resource

  def index
    @secret_codes = SecretCode.includes(:user).paginate(:page => params[:page], :per_page => 30)
  end

  def create
    created_codes = SecretCode.generate(secret_code_params[:number_of_code])
    if created_codes == 0
      flash[:error] = 'Something went wrong.'
    else
      flash[:notice] = 'Secret code was successfully created.'
    end

    redirect_to secret_codes_path
  end

  # DELETE /secret_codes/1
  # DELETE /secret_codes/1.json
  def destroy
    respond_to do |format|
      if @secret_code.destroy
        format.html {redirect_to secret_codes_url, notice: 'Secret code was successfully destroyed.'}
        format.json {head :no_content}
      else
        format.html {redirect_to secret_codes_url, :alert => "An Error Occurred! #{@secret_code.errors[:base]*''}"}
        format.json {head :no_content}
      end
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_secret_code
    @secret_code = SecretCode.find(params[:id])
  end

  def secret_code_params
    params.permit(:number_of_code)
  end
end
