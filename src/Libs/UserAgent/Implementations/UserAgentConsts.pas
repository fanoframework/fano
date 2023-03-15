{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit UserAgentConsts;

interface

{$MODE OBJFPC}
{$H+}


const

    (*!------------------------------------------------
     * constant related to browser, OS identification
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     * @credit https://github.com/serbanghita/Mobile-Detect
     *-----------------------------------------------*)

    {
        MIT License

        Copyright (c) <2011-2015> Serban Ghita, Nick Ilyin and contributors.

        Permission is hereby granted, free of charge, to any person obtaining
        a copy of this software and associated documentation files (the
        "Software"), to deal in the Software without restriction, including
        without limitation the rights to use, copy, modify, merge, publish,
        distribute, sublicense, and/or sell copies of the Software, and to
        permit persons to whom the Software is furnished to do so, subject to
        the following conditions:

        The above copyright notice and this permission notice shall be included
        in all copies or substantial portions of the Software.

        THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
        OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
        MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
        IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
        CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
        TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
        SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

        Developer’s Certificate of Origin 1.1

        By making a contribution to this project, I certify that:

        (a) The contribution was created in whole or in part by me and I
            have the right to submit it under the open source license
            indicated in the file; or

        (b) The contribution is based upon previous work that, to the best
            of my knowledge, is covered under an appropriate open source
            license and I have the right under that license to submit that
            work with modifications, whether created in whole or in part
            by me, under the same open source license (unless I am
            permitted to submit under a different license), as indicated
            in the file; or

        (c) The contribution was provided directly to me by some other
            person who certified (a), (b) or (c) and I have not modified
            it.

        (d) I understand and agree that this project and the contribution
            are public and that a record of the contribution (including all
            personal information I submit with it, including my sign-off) is
            maintained indefinitely and may be redistributed consistent with
            this project or the open source license(s) involved.
    }

    REGEX_VER = '([\w._\+]+)';

    REGEX_CHROME = 'Chrome/[.0-9]*|\bCrMo\b|CriOS|Android.*Chrome/[.0-9]* (Mobile)?';
    REGEX_FIREFOX = 'Firefox/[.0-9]*|fennec|firefox.*maemo|(Mobile|Tablet).*Firefox|Firefox.*Mobile|FxiOS';
    REGEX_SAFARI = 'Version.*Mobile.*Safari|Safari.*Mobile|MobileSafari';
    REGEX_EDGE = 'Mobile Safari/[.0-9]* Edge';
    REGEX_OPERA = 'Opera.*Mini|Opera.*Mobi|Android.*Opera|Mobile.*OPR/[0-9.]+$|Coast/[0-9.]+';
    REGEX_IE = 'IEMobile|MSIEMobile';
    REGEX_GENERIC = 'NokiaBrowser|OviBrowser|OneBrowser|TwonkyBeamBrowser|SEMC.*Browser|FlyFlow|Minimo|NetFront|Novarra-Vision|MQQBrowser|MicroMessenger';
    REGEX_DOLFIN = '\bDolfin\b';
    REGEX_SKYFIRE = 'Skyfire';
    REGEX_BOLT = 'bolt';
    REGEX_UCBROWSER = 'UC.*Browser|UCWEB';
    REGEX_BAIDU = 'baidubrowser';
    REGEX_TEASHARK = 'teashark';
    REGEX_BLAZER = 'Blazer';
    REGEX_WECHAT = '\bMicroMessenger\b';

    BROWSER_CHROME = 'Chrome';
    BROWSER_FIREFOX = 'Firefox';
    BROWSER_SAFARI = 'Safari';
    BROWSER_EDGE = 'Edge';
    BROWSER_OPERA = 'Opera';
    BROWSER_IE = 'IE';
    BROWSER_GENERIC = 'GenericBrowser';
    BROWSER_DOLFIN = 'Dolfin';
    BROWSER_SKYFIRE = 'Skyfire';
    BROWSER_BOLT = 'Bolt';
    BROWSER_UCBROWSER = 'UCBrowser';
    BROWSER_BAIDU = 'baidubrowser';
    BROWSER_TEASHARK = 'TeaShark';
    BROWSER_BLAZER = 'Blazer';
    BROWSER_WECHAT = 'WeChat';


    //OS-related constant
    REGEX_ANDROID = 'Android';
    REGEX_BLACKBERRY = 'blackberry|\bBB10\b|rim tablet os';
    REGEX_IOS = '\biPhone.*Mobile|\biPod|\biPad|AppleCoreMedia';
    REGEX_PALMOS = 'PalmOS|avantgo|blazer|elaine|hiptop|palm|plucker|xiino';
    REGEX_SYMBIAN = 'Symbian|SymbOS|Series60|Series40|SYB-[0-9]+|\bS60\b';
    REGEX_WINDOWS_MOBILE = 'Windows CE.*(PPC|Smartphone|Mobile|[0-9]{3}x[0-9]{3})|Windows Mobile|Windows Phone [0-9.]+|WCE;';
    REGEX_WINDOWS_PHONE = 'Windows Phone 10.0|Windows Phone 8.1|Windows Phone 8.0|Windows Phone OS|XBLWP7|ZuneWP7|Windows NT 6.[23]; ARM;';
    REGEX_JAVA = 'J2ME/|\bMIDP\b|\bCLDC\b';
    REGEX_WEBOS = 'webOS|hpwOS';
    REGEX_LINUX = 'Linux';

    OS_ANDROID = 'AndroidOS';
    OS_BLACKBERRY = 'BlackBerryOS';
    OS_IOS = 'iOS';
    OS_PALMOS = 'PalmOS';
    OS_SYMBIAN = 'SymbianOS';
    OS_WINDOWS_MOBILE = 'WindowsMobileOS';
    OS_WINDOWS_PHONE = 'WindowsPhoneOS';
    OS_JAVA = 'JavaOS';
    OS_WEBOS = 'webOS';
    OS_LINUX = 'Linux';

implementation
end.
