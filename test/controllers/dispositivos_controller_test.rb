require 'test_helper'

class DispositivosControllerTest < ActionController::TestCase
  setup do
    @dispositivo = dispositivos(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:dispositivos)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create dispositivo" do
    assert_difference('Dispositivo.count') do
      post :create, dispositivo: { descripcion: @dispositivo.descripcion, fabricante: @dispositivo.fabricante, fecha: @dispositivo.fecha, ip: @dispositivo.ip, modelo: @dispositivo.modelo, nombre: @dispositivo.nombre, passenable: @dispositivo.passenable, passsh: @dispositivo.passsh, serie: @dispositivo.serie, tipo: @dispositivo.tipo }
    end

    assert_redirected_to dispositivo_path(assigns(:dispositivo))
  end

  test "should show dispositivo" do
    get :show, id: @dispositivo
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @dispositivo
    assert_response :success
  end

  test "should update dispositivo" do
    patch :update, id: @dispositivo, dispositivo: { descripcion: @dispositivo.descripcion, fabricante: @dispositivo.fabricante, fecha: @dispositivo.fecha, ip: @dispositivo.ip, modelo: @dispositivo.modelo, nombre: @dispositivo.nombre, passenable: @dispositivo.passenable, passsh: @dispositivo.passsh, serie: @dispositivo.serie, tipo: @dispositivo.tipo }
    assert_redirected_to dispositivo_path(assigns(:dispositivo))
  end

  test "should destroy dispositivo" do
    assert_difference('Dispositivo.count', -1) do
      delete :destroy, id: @dispositivo
    end

    assert_redirected_to dispositivos_path
  end
end
