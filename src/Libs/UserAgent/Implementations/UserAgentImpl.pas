{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit UserAgentImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    RegexIntf,
    ListIntf,
    UserAgentIntf,
    ClientDeviceIntf,
    ClientOsIntf,
    ClientBrowserIntf,
    InjectableObjectImpl;

type

    (*!------------------------------------------------
     * interface for any class having capability to get
     * client user agent string
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TUserAgent = class(TInjectableObject, IUserAgent, IClientDevice, IClientOs, IClientBrowser)
    private
        fRegex : IRegex;
        fRules : IList;
        fUserAgentStr : string;

        procedure addRule(const rules : IList; const key : shortstring; const regex: string);

        procedure initRules(const rules : IList);
        procedure cleanRules(const rules : IList);
        procedure resetMatchedRules(const rules : IList);

        function isMatched(const keyName : shortstring) : boolean;
    protected
        procedure initOSRules(const rules : IList); virtual;
        procedure initBrowserRules(const rules : IList); virtual;
    public
        constructor create(const regex : IRegex; const rules : IList);
        destructor destroy(); override;
        procedure setUserAgent(const ua : string);
        function getUserAgent() : string;
        function isMobile() : boolean;
        function isOS(const osName : shortString) : boolean;
        function isBrowser(const browserName : shortstring) : boolean;

        function getBrowser() : IClientBrowser;
        function getOS() : IClientOS;
        function getDevice() : IClientDevice;

        property userAgent : string read getUserAgent write setUserAgent;
        property OS[const osName : shortString] : boolean read isOS;
        property browser[const browserName : shortstring] : boolean read isBrowser;
    end;

implementation

uses

    UserAgentConsts;

type

    TMatchRule = record
        key : shortstring;
        regex : string;
        matched : boolean;
    end;
    PMatchRule = ^TMatchRule;

    constructor TUserAgent.create(const regex : IRegex; const rules : IList);
    begin
        fRegex := regex;
        fRules := rules;
        initRules(fRules);
    end;

    destructor TUserAgent.destroy();
    begin
        cleanRules(fRules);
        fRules := nil;
        fRegex := nil;
        inherited destroy();
    end;

    procedure TUserAgent.addRule(const rules : IList; const key : shortstring; const regex: string);
    var arule : PMatchRule;
    begin
        new(arule);
        arule^.key := key;
        arule^.regex := regex;
        arule^.matched := false;
        rules.add(key, arule);
    end;

    procedure TUserAgent.initBrowserRules(const rules : IList);
    begin
        addRule(rules, BROWSER_CHROME, REGEX_CHROME);
        addRule(rules, BROWSER_FIREFOX, REGEX_FIREFOX);
        addRule(rules, BROWSER_SAFARI, REGEX_SAFARI);
        addRule(rules, BROWSER_EDGE, REGEX_EDGE);
        addRule(rules, BROWSER_OPERA, REGEX_OPERA);
        addRule(rules, BROWSER_IE, REGEX_IE);
    end;

    procedure TUserAgent.initOSRules(const rules : IList);
    begin
        addRule(rules, OS_ANDROID, REGEX_ANDROID);
        addRule(rules, OS_IOS, REGEX_IOS);
        addRule(rules, OS_BLACKBERRY, REGEX_BLACKBERRY);
        addRule(rules, OS_SYMBIAN, REGEX_SYMBIAN);
        addRule(rules, OS_WINDOWS_PHONE, REGEX_WINDOWS_PHONE);
        addRule(rules, OS_WINDOWS_MOBILE, REGEX_WINDOWS_MOBILE);
        addRule(rules, OS_JAVA, REGEX_JAVA);
        addRule(rules, OS_PALMOS, REGEX_PALMOS);
        addRule(rules, OS_WEBOS, REGEX_WEBOS);
        addRule(rules, OS_LINUX, REGEX_LINUX);
    end;

    procedure TUserAgent.initRules(const rules : IList);
    begin
        initBrowserRules(rules);
        initOSRules(rules);
    end;

    procedure TUserAgent.cleanRules(const rules : IList);
    var rule : PMatchRule;
        i : integer;
    begin
        for i:= rules.count() - 1 downto 0 do
        begin
            rule := rules.get(i);
            dispose(rule);
            rules.delete(i);
        end;
    end;

    procedure TUserAgent.resetMatchedRules(const rules : IList);
    var rule : PMatchRule;
        i : integer;
    begin
        for i:= rules.count() - 1 downto 0 do
        begin
            rule := rules.get(i);
            rule^.matched := false;
        end;
    end;

    procedure TUserAgent.setUserAgent(const ua : string);
    begin
        if (fUserAgentStr <> ua) then
        begin
            fUserAgentStr := ua;
            resetMatchedRules(fRules);
        end;
    end;

    function TUserAgent.getUserAgent() : string;
    begin
        result := fUserAgentStr;
    end;

    function TUserAgent.isMobile() : boolean;
    begin
        result := isOS(OS_ANDROID) or
            isOS(OS_IOS) or
            isOS(OS_WINDOWS_PHONE) or
            isOS(OS_BLACKBERRY) or
            isOS(OS_PALMOS) or
            isOS(OS_SYMBIAN) or
            isOS(OS_WINDOWS_MOBILE) or
            isOS(OS_JAVA) or
            isOS(OS_WEBOS);
    end;

    function TUserAgent.isMatched(const keyName : shortstring) : boolean;
    var arule : PMatchRule;
        res : TRegexMatchResult;
    begin
        arule := fRules.find(keyName);
        result := (arule <> nil) and arule^.matched;
        if (arule <> nil) and (not arule^.matched) then
        begin
            res := fRegex.match(arule^.regex, fUserAgentStr);
            //cache match result for speedup future match
            arule^.matched := res.matched;
            result := res.matched;
        end;
    end;

    function TUserAgent.isOS(const osName : shortString) : boolean;
    begin
        result := isMatched(osName);
    end;

    function TUserAgent.isBrowser(const browserName : shortString) : boolean;
    begin
        result := isMatched(browserName);
    end;

    function TUserAgent.getBrowser() : IClientBrowser;
    begin
        result := self;
    end;

    function TUserAgent.getOS() : IClientOS;
    begin
        result := self;
    end;

    function TUserAgent.getDevice() : IClientDevice;
    begin
        result := self;
    end;

end.
