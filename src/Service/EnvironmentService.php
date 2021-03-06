<?php

namespace App\Service;

use Detection\MobileDetect;

class EnvironmentService
{
    private $mobileDetect;

    public function __construct(MobileDetect $mobileDetect)
    {
        $this->mobileDetect = $mobileDetect;
    }

    /**
     * Returns information about building browser
     * @return array
     */
    public function getBrowser()
    {
        $u_agent = $_SERVER['HTTP_USER_AGENT'];
        $version = "";

        //First get the platform?
        if (preg_match('/linux/i', $u_agent)) {
            $platform = 'linux';
        } elseif (preg_match('/macintosh|mac os x/i', $u_agent)) {
            $platform = 'mac';
        } elseif (preg_match('/windows|win32/i', $u_agent)) {
            $platform = 'windows';
        } else {
            $platform = 'windows tester';
        }

        // Next get the name of the useragent yes seperately and for good reason
        if (preg_match('/MSIE/i',$u_agent) && !preg_match('/Opera/i',$u_agent)) {
            $bname = 'Internet Explorer';
            $ub = "MSIE";
        } elseif(preg_match('/Firefox/i',$u_agent)) {
            $bname = 'Mozilla Firefox';
            $ub = "Firefox";
        } elseif(preg_match('/Chrome/i',$u_agent)) {
            $bname = 'Google Chrome';
            $ub = "Chrome";
        } elseif(preg_match('/Safari/i',$u_agent)) {
            $bname = 'Apple Safari';
            $ub = "Safari";
        } elseif(preg_match('/Opera/i',$u_agent)) {
            $bname = 'Opera';
            $ub = "Opera";
        } elseif(preg_match('/Netscape/i',$u_agent)) {
            $bname = 'Netscape';
            $ub = "Netscape";
        } else {
            $bname =  'PhpBrowser - tester';
            $ub = 'PhpBrowser - tester';
        }

        // finally get the correct version number
        $known = array('Version', $ub, 'other');

        $pattern = '#(?<browser>' . join('|', $known) .
            ')[/ ]+(?<version>[0-9.|a-zA-Z.]*)#';

        if (!preg_match_all($pattern, $u_agent, $matches)) {
            // we have no matching number just continue
        } else {
            // see how many we have
            $i = count($matches['browser']);

            if ($i != 1 && $i > 0) {
                //we will have two since we are not using 'other' argument yet
                //see if version is before or after the name
                if (strripos($u_agent, "Version") < strripos($u_agent, $ub)){
                    $version = $matches['version'][0];
                } else {
                    $version = $matches['version'][1];
                }
            } else {
                $version = $matches['version'][0];
            }
        }

        // check if we have a number
        if ($version == null || $version == "") { $version="?"; }

        return [
            'userAgent' => $u_agent,
            'name'      => $bname,
            'version'   => $version,
            'platform'  => $platform,
            'pattern'    => $pattern
        ];
    }

    /**
     * Returns building IP address
     * @return mixed
     */
    public function getRealIpAddress()
    {
        if (!empty($_SERVER['HTTP_CLIENT_IP'])) { // check ip from share internet
            $ip = $_SERVER['HTTP_CLIENT_IP'];
        } elseif (!empty($_SERVER['HTTP_X_FORWARDED_FOR'])) { // to check ip is pass from proxy
            $ip = $_SERVER['HTTP_X_FORWARDED_FOR'];
        } else {
            $ip = $_SERVER['REMOTE_ADDR'];
        }

        return $ip;
    }

    /**
     * @return array|bool
     */
    public function getEnvironment()
    {
        if (!isset($_SERVER['HTTP_USER_AGENT'])) {
            return false;
        }

        $browser = $this->getBrowser();
        $ip = $this->getRealIpAddress();

        // Do not return a device for testing environment
        if ($ip == null || $browser['version'] == null || $browser['version'] == null
            || strstr('test', $browser['platform']) || strstr('test', $browser['name'])
        ) {
            return false;
        }

        $deviceType = ($this->mobileDetect->isMobile()
            ? ($this->mobileDetect->isTablet() ? 'tablet' : 'phone')
            : 'computer');

        $environment = [
            'ip' => $ip,
            'isComputer' => $deviceType == 'computer',
            'device' => $deviceType,
            'os' => $browser['platform'],
            'browser' => $browser['name'],
            'browserVersion' => $browser['version']
        ];

        return $environment;
    }
}