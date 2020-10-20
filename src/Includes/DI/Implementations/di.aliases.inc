{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

(*! ---------------------------------------------
 * alias for dependency container classes
 * that is included in fano.pas unit
 *
 * @author Zamrony P. Juhara <zamronypj@yahoo.com>
 *-----------------------------------------------*)

TDependencyContainer = DependencyContainerImpl.TDependencyContainer;
TDependencyList = DependencyListImpl.TDependencyList;
TInjectableObject = InjectableObjectImpl.TInjectableObject;
TFactory = FactoryImpl.TFactory;
EDependencyNotFound = EDependencyNotFoundImpl.EDependencyNotFound;
EInvalidFactory = EInvalidFactoryImpl.EInvalidFactory;
EDependencyAlias = EDependencyAliasImpl.EDependencyAlias;

TBasicContainerFactory = BasicContainerFactoryImpl.TBasicContainerFactory;

TCompositeServiceProvider = CompositeServiceProviderImpl.TCompositeServiceProvider;
