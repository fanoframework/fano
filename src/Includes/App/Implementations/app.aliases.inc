{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

(*! ---------------------------------------------
 * redeclare all class types in unit inside App
 * directory
 *
 * @author Zamrony P. Juhara <zamronypj@yahoo.com>
 *-----------------------------------------------*)

TCgiWebApplication = AppImpl.TCgiWebApplication;
TDaemonWebApplication = DaemonAppImpl.TDaemonWebApplication;
TCgiFcgiGatewayApplication = CgiFcgiGatewayAppImpl.TCgiFcgiGatewayApplication;

TBasicAppServiceProvider = BasicAppServiceProviderImpl.TBasicAppServiceProvider;
TDaemonAppServiceProvider = DaemonAppServiceProviderImpl.TDaemonAppServiceProvider;
TServerAppServiceProvider = ServerAppServiceProviderImpl.TServerAppServiceProvider;
TDecoratorAppServiceProvider = DecoratorAppServiceProviderImpl.TDecoratorAppServiceProvider;
TDecoratorDaemonAppServiceProvider = DecoratorDaemonAppServiceProviderImpl.TDecoratorDaemonAppServiceProvider;
TAdapterDaemonAppServiceProvider = AdapterDaemonAppServiceProviderImpl.TAdapterDaemonAppServiceProvider;

{----------------Begin FastCGI related-----------------------------}
TFastCgiAppServiceProvider = FastCgiAppServiceProviderImpl.TFastCgiAppServiceProvider;
{---------------- End FastCGI related-----------------------------}

{----------------Begin SCGI related-----------------------------}
TScgiAppServiceProvider = ScgiAppServiceProviderImpl.TScgiAppServiceProvider;
{---------------- End SCGI related-----------------------------}

{----------------Begin uwsgi related-----------------------------}
TUwsgiAppServiceProvider = UwsgiAppServiceProviderImpl.TUwsgiAppServiceProvider;
{---------------- End uwsgi related-----------------------------}
