tick('b1');
tick('fs0');
resizeApp();
function getTileUrl(baseUrls, tile, zoom) {
    var i = (tile.x + 2 * tile.y) % baseUrls.length,
    salt = "Galileo".substr(0, (tile.x * 3 + tile.y) % 8),
    middleSalt = "";
    if (tile.y >= 1E4 && tile.y < 1E5) middleSalt = "&s=";
    return [baseUrls[i], "x=", tile.x, middleSalt, "&y=", tile.y, "&z=", zoom, "&s=", salt].join("")
};
function hasCookie(doc, cookieName) {
    return doc.cookie.indexOf(cookieName) != -1
}
function checkCookie(domain, opt_document) {
    if (!domain) return true;
    try {
        var doc = opt_document || document;
        setCookie(domain, "testcookie", "1", "", "", doc);
        if (hasCookie(doc, "testcookie")) {
            setCookie(domain, "testcookie", "1", "", "Thu, 01-Jan-1970 00:00:01 GMT", doc);
            return true
        }
    } catch(e) {}
    return false
}
function setCookie(domain, name, value, opt_path, opt_expiry, opt_document) { (opt_document || document).cookie = [name, "=", value, "; domain=.", domain, opt_path ? "; path=/" + opt_path: "", opt_expiry ? "; expires=" + opt_expiry: ""].join("")
};
function TileOverride(tileOverrides) {
    this.overrides_ = tileOverrides
}
var TileOverride$fromLatLngRect = function(override, latLngToPixel, tileSize, maxResolution) {
    for (var expandedOverride = [], numOverrides = override ? override.length: 0, i = 0; i < numOverrides; ++i) {
        for (var o = {
            minZoom: override[i].minZoom || 1,
            maxZoom: override[i].maxZoom || maxResolution,
            uris: override[i].uris,
            rect: []
        },
        numRects = override[i].rect ? override[i].rect.length: 0, j = 0; j < numRects; ++j) {
            o.rect[j] = [];
            for (var z = o.minZoom; z <= o.maxZoom; ++z) {
                var loPixel = latLngToPixel(override[i].rect[j].lo.lat_e7 / 1E7, override[i].rect[j].lo.lng_e7 /
                1E7, z),
                hiPixel = latLngToPixel(override[i].rect[j].hi.lat_e7 / 1E7, override[i].rect[j].hi.lng_e7 / 1E7, z);
                o.rect[j][z] = {
                    n: Math.floor(hiPixel.y / tileSize),
                    w: Math.floor(loPixel.x / tileSize),
                    s: Math.floor(loPixel.y / tileSize),
                    e: Math.floor(hiPixel.x / tileSize)
                }
            }
        }
        expandedOverride.push(o)
    }
    return expandedOverride ? new TileOverride(expandedOverride) : null
};
TileOverride.prototype.getBaseUris = function(tile, zoom) {
    var overrides = this.overrides_;
    if (!overrides) return null;
    for (var i = 0; i < overrides.length; ++i) if (! (overrides[i].minZoom > zoom || overrides[i].maxZoom < zoom)) {
        var numRects = overrides[i].rect ? overrides[i].rect.length: 0;
        if (numRects == 0) return overrides[i].uris;
        for (var j = 0; j < numRects; ++j) {
            var bounds = overrides[i].rect[j][zoom];
            if (bounds.n <= tile.y && bounds.s >= tile.y && bounds.w <= tile.x && bounds.e >= tile.x) return overrides[i].uris
        }
    }
    return null
};
function alignWithMapCenter(ids) {
    for (var map = e("map"), centerLeft = Math.round(map.offsetWidth / 2), centerTop = Math.round(map.offsetHeight / 2), i = 0; i < ids.length; ++i) {
        var element = e(ids[i]);
        if (element) {
            element.style.left = centerLeft + "px";
            element.style.top = centerTop + "px"
        }
    }
};
function hideControlsBasedOnViewportSize(controlCoverage, hide) {
    for (var halfWidth = e("map").offsetWidth / 2, halfHeight = e("map").offsetHeight / 2, i = 0; i < controlCoverage.length; ++i) {
        var node = e(controlCoverage[i].id);
        if (node) {
            for (var distance = controlCoverage[i].feature_distance, found = false, j = 0; j < distance.length; ++j) if (halfWidth > distance[j].x && halfHeight > distance[j].y) {
                found = true;
                break
            }
            found || hide(node.id)
        }
    }
};
function e(id) {
    return document.getElementById(id)
}
function v(id) {
    return e(id).value
}
function vs(id, val) {
    e(id).value = val
}
function d0(id) {
    e(id).style.display = "none"
}
function d1(id) {
    e(id).style.display = ""
}
function u(v) {
    return typeof v == "undefined"
}
function GXhrGet(url, opt_callback) {
    var req;
    if (window.XMLHttpRequest) req = new XMLHttpRequest;
    else if (typeof ActiveXObject != "undefined") req = new ActiveXObject("Microsoft.XMLHTTP");
    req.onreadystatechange = function() {
        if (req.readyState == 4) if (req.status == 200) {
            opt_callback && opt_callback(req.responseText);
            req.onreadystatechange = function() {}
        }
    };
    req.open("GET", url, true);
    req.send("")
};
function appendKeyholeAuthtoken(keyholeAuthtoken, baseUrls) {
    if (!keyholeAuthtoken) return baseUrls;
    for (var i = 0; i < baseUrls.length; ++i) baseUrls[i] += keyholeAuthtoken;
    return baseUrls
}
function createTileElement(tileUrl, x, y, transparent) {
    return transparent && /MSIE 6/i.test(navigator.userAgent) ? ['<div style="left:', x * 256, "px;top:", y * 256, "px;filter:progid:DXImageTransform.Microsoft.AlphaImageLoader(sizingMethod=crop,src='", tileUrl, '"', '__src__="' + tileUrl + '"', "></div>"].join("") : ['<img style="position:absolute; left:', x * 256, "px; top:", y * 256, 'px;" src="', tileUrl, '">'].join("")
}
function convertPairsToMap(pairs) {
    for (var map = {},
    i = 0; i < pairs.length; ++i) map[pairs[i].key] = pairs[i].value;
    return map
}
var INSERT_TILES_LYRS_PARAM_REGEX_ = /([?/ & ]) lyrs = [ ^ &] + /;function getTileSpecificUris(zoom,x,y,tileLyrsMap,uris){for(var result=[],newLyrsParam=tileLyrsMap[zoom+"_"+x+"_"+y],i=0;i<uris.length;++i)newLyrsParam?result.push(uris[i].replace(INSERT_TILES_LYRS_PARAM_REGEX_,"$1lyrs="+newLyrsParam)):result.push(uris[i]);return result}
function insertTiles(tileContainer,size,lat,lng,zoom,baseUrls,tileOverrides,transparent,opt_domain,opt_authtoken,opt_tileLyrsPairs){var centerPixel=latLngToPixel(lat,lng,zoom),offset={x:centerPixel.x%256,y:centerPixel.y%256},centerTile={x:Math.floor(centerPixel.x/256), y: Math.floor(centerPixel.y / 256)
},
nWrapTiles = Math.pow(2, zoom), wrapSize = nWrapTiles * 256, nLeft = Math.ceil((size.w / 2 - offset.x) / 256), nTop = Math.ceil((size.h / 2 - offset.y) / 256);
if (centerTile.y - nTop < 0) nTop = centerTile.y;
var nRight = Math.ceil((size.w /
2 - 256 + offset.x) / 256), nBottom = Math.ceil((size.h / 2 - 256 + offset.y) / 256);
if (centerTile.y + nBottom >= nWrapTiles) nBottom = nWrapTiles - centerTile.y - 1;
var domOffset = {
    x: offset.x + nLeft * 256,
    y: offset.y + nTop * 256
};tileContainer.style.left = "-" + Math.round(domOffset.x) + "px";tileContainer.style.top = "-" + Math.round(domOffset.y) + "px";
var upperLeftTile = {
    x: centerTile.x - nLeft,
    y: centerTile.y - nTop
},
x0 = upperLeftTile.x, y0 = upperLeftTile.y, x1 = x0 + nLeft + nRight, y1 = y0 + nTop + nBottom, keyholeAuthtoken = opt_authtoken ? "cookie=" + opt_authtoken +
"&": "";
if (opt_authtoken && opt_domain && checkCookie(opt_domain)) {
    setCookie(opt_domain, "khcookie", opt_authtoken, "kh");
    keyholeAuthtoken = ""
}
baseUrls = appendKeyholeAuthtoken(keyholeAuthtoken, baseUrls);
for (var tileOverridePixelRect = TileOverride$fromLatLngRect(tileOverrides, latLngToPixel, 256, zoom), tileLyrsMap = null, htmlList = [], y = y0; y <= y1; y++) for (var x = x0; x <= x1; x++) {
    var wrappedx = x;
    if (wrappedx < 0) wrappedx = (Math.abs(Math.floor(x / nWrapTiles)) * nWrapTiles + x) % nWrapTiles;
    else if (wrappedx >= nWrapTiles) wrappedx %= nWrapTiles;
    var tile = {
        x: wrappedx,
        y: y
    },
    uris = tileOverridePixelRect.getBaseUris(tile, zoom) || baseUrls;
    if (opt_tileLyrsPairs) {
        tileLyrsMap || (tileLyrsMap = convertPairsToMap(opt_tileLyrsPairs));
        uris = getTileSpecificUris(zoom, tile.x, tile.y, tileLyrsMap, uris)
    }
    htmlList.push(createTileElement(getTileUrl(uris, tile, zoom), x - x0, y - y0, transparent))
}
tileContainer.innerHTML = htmlList.join("");tileContainer.style.display = "block"
}
function latLngToPixel(lat, lng, zoom) {
    var centerPoint = Math.pow(2, zoom + 7),
    totalPixels = centerPoint * 2,
    siny = Math.min(Math.max(Math.sin(lat * (Math.PI / 180)), -0.9999), 0.9999);
    return {
        x: Math.round(centerPoint + lng * (totalPixels / 360)),
        y: Math.round(centerPoint - 0.5 * Math.log((1 + siny) / (1 - siny)) * (totalPixels / (2 * Math.PI)))
    }
};
function repositionInlineMapControls(control_ids) {
    for (var firstNode = e(control_ids[0]), anchorNode = firstNode.firstChild, offset = 14 - anchorNode.offsetLeft, i = 1; i < control_ids.length; ++i) {
        var control = e(control_ids[i]);
        if (control) {
            control.style.right = px(offset);
            control.style.width = px(control.clientWidth);
            offset += 7 + control.offsetWidth
        }
    }
    firstNode.style.width = px( - anchorNode.offsetLeft);
    firstNode.style.height = px(anchorNode.offsetHeight)
}
function repositionInlineZoomControls(numLevels) {
    var map = document.getElementById("map"),
    inlineZoomSlider = document.getElementById("zoom_slider_inline"),
    inlineZoomOut = document.getElementById("zoom_out_inline"),
    inlineZoomOutImg = document.getElementById("zoom_out_inline_img"),
    inlineZoomSliderContainer = document.getElementById("inline_zoom_slider_container");
    if (!map || !inlineZoomSlider || !inlineZoomOut || !inlineZoomOutImg || !inlineZoomSliderContainer) return false;
    var minZoom = getBoundsZoomLevel( - 85, -180, 85, 180, map.clientWidth, map.clientHeight);
    if (map.clientHeight < 240 + (numLevels + minZoom) * 8) {
        inlineZoomOut.style.height = px(23);
        inlineZoomOutImg.style.top = px( - 360);
        inlineZoomOut.style.top = px(53);
        inlineZoomSlider.style.height = px(25);
        inlineZoomSliderContainer.style.display = "none";
        return minZoom == 0
    }
    if (minZoom == 0) {
        var topZoomOutButton = inlineZoomOut.offsetTop;
        inlineZoomSlider.style.height = px(inlineZoomSlider.offsetHeight + 8);
        inlineZoomOut.style.top = px(topZoomOutButton + 8);
        return true
    }
    return false
}
function getBoundsZoomLevel(south, west, north, east, width, height) {
    for (var z = 30; z >= 1; --z) {
        var blPixel = latLngToPixel(south, west, z),
        trPixel = latLngToPixel(north, east, z);
        if (blPixel.x > trPixel.x) blPixel.x -= Math.pow(2, z + 8);
        if (Math.abs(trPixel.x - blPixel.x) <= width && Math.abs(trPixel.y - blPixel.y) <= height) return z
    }
    return 0
}
function px(numPixels) {
    return numPixels + "px"
}; (function() {
    var control_coverage = [{
        id: 'pegman_inline',
        feature_distance: [{
            x: 0,
            y: 0
        }]
    }];
    hideControlsBasedOnViewportSize(control_coverage, d0);
})(); (function() {
    var num_zoom_slider_levels = 19;
    window.extraZoomLevel = repositionInlineZoomControls(num_zoom_slider_levels) ? 1: 0;
})(); (function() {
    var ids = ['mapCenter'];
    alignWithMapCenter(ids);
})();tick('iit0'); (function() {
    var viewport_center_lat = 38.912376403808594;
    var viewport_center_lng = -77.002426147460938;
    var zoom = 19;
    var initial_base_urls = ['http://mt0.google.com/vt/lyrs\x3dm@154\x26hl\x3den\x26', 'http://mt1.google.com/vt/lyrs\x3dm@154\x26hl\x3den\x26'];
    var initial_overrides = [];
    var inline_satellite_tiles_cookie_domain = '';
    var inline_satellite_tiles_authtoken = '';
    var inline_tile_lyrs_pair = [{
        key: '19_149999_200534',
        value: 'm@154'
    },
    {
        key: '19_149999_200535',
        value: 'm@154'
    },
    {
        key: '19_149999_200536',
        value: 'm@154'
    },
    {
        key: '19_149999_200537',
        value: 'm@154'
    },
    {
        key: '19_149999_200538',
        value: 'm@154'
    },
    {
        key: '19_150000_200534',
        value: 'm@154'
    },
    {
        key: '19_150000_200535',
        value: 'm@154'
    },
    {
        key: '19_150000_200536',
        value: 'm@154'
    },
    {
        key: '19_150000_200537',
        value: 'm@154'
    },
    {
        key: '19_150000_200538',
        value: 'm@154'
    },
    {
        key: '19_150001_200534',
        value: 'm@154'
    },
    {
        key: '19_150001_200535',
        value: 'm@154'
    },
    {
        key: '19_150001_200536',
        value: 'm@154'
    },
    {
        key: '19_150001_200537',
        value: 'm@154'
    },
    {
        key: '19_150001_200538',
        value: 'm@154'
    },
    {
        key: '19_150002_200534',
        value: 'm@154'
    },
    {
        key: '19_150002_200535',
        value: 'm@154'
    },
    {
        key: '19_150002_200536',
        value: 'm@154'
    },
    {
        key: '19_150002_200537',
        value: 'm@154'
    },
    {
        key: '19_150002_200538',
        value: 'm@154'
    },
    {
        key: '19_150003_200534',
        value: 'm@154'
    },
    {
        key: '19_150003_200535',
        value: 'm@154'
    },
    {
        key: '19_150003_200536',
        value: 'm@154'
    },
    {
        key: '19_150003_200537',
        value: 'm@154'
    },
    {
        key: '19_150003_200538',
        value: 'm@154'
    }];
    insertTiles(e('inlineTiles'), {
        w: e('map').offsetWidth,
        h: e('map').offsetHeight
    },
    viewport_center_lat, viewport_center_lng, zoom, initial_base_urls, initial_overrides, false, inline_satellite_tiles_cookie_domain, inline_satellite_tiles_authtoken, inline_tile_lyrs_pair);
})();tick('iit1');
function constructEventQueue(queue, handler) {
    return {
        q: queue,
        h: handler
    }
}
function addDocListener(eventName, fn) {
    if (document.addEventListener) {
        document.addEventListener(eventName, fn, false);
    } else if (document.attachEvent) {
        document.attachEvent("on" + eventName, fn);
    }
}
function removeDocListener(eventName, fn) {
    if (document.removeEventListener) {
        document.removeEventListener(eventName, fn, false);
    } else if (document.detachEvent) {
        document.detachEvent("on" + eventName, fn);
    }
}
window.gEventQueue = (function() {
    function getJsactionNodeForQueuing_(e) {
        var node = e.srcElement || e.target;
        if (node.nodeType == 3) node = node.parentNode;
        var isMac = /Macintosh/.test(navigator.userAgent);
        var modified = (isMac && e.metaKey || !isMac && e.ctrlKey);
        var re = modified ? /^click(modified)?:/: /^[^:]*$|^click(plain)?:/;
        while (node) {
            var attr = (node.getAttribute && node.getAttribute('jsaction'));
            if (attr) {
                for (var i = 0, actions = attr.split(';'); i < actions.length; i++) {
                    if (re.test(actions[i])) {
                        return node;
                    }
                }
            }
            node = node.parentNode;
        }
        return null;
    }
    var queue = [];
    function handler(e) {
        var node = getJsactionNodeForQueuing_(e);
        if (!node) return;
        e.replayTimeStamp = (new Date).getTime();
        e.stopPropagation ? e.stopPropagation() : (e.cancelBubble = true);
        if (node.tagName == 'A' && e.type == 'click') {
            e.preventDefault ? e.preventDefault() : (e.returnValue = false);
        }
        var copy = {};
        for (var i in e) {
            copy[i] = e[i];
        }
        queue.push(copy);
    }
    addDocListener('click', handler);
    return constructEventQueue(queue, handler);
} ()); (function() {
    var init_timeout = 5000;
    setTimeout(function() {
        GLoadMapsScript();
        vpLoad.arg(0, 'ait').check();
    },
    init_timeout);
})(); (function() {
    var main_js_before_onload = false;
    var not_fully_inlined = false;
    window.jsLoadCallback = function(appOptions) {
        vpLoad.arg(3, appOptions).check();
        if (main_js_before_onload) {
            vpLoad.arg(0, 'aij1').check();
        }
        if (not_fully_inlined) {
            vpLoad.arg(0, 'aijl').check();
        }
    };
})();
function GScript(src) {
    var s = document.createElement('script');
    s.src = src;
    document.body.appendChild(s);
}
function GBrowserIsCompatible() {
    return true;
} (function() {
    var jslinker = {
        version: "182",
        jsbinary: [{
            id: "maps2",
            url: "http://maps.gstatic.com/intl/en_us/mapfiles/340c/maps2/main.js"
        },
        {
            id: "maps2.api",
            url: "http://maps.gstatic.com/intl/en_us/mapfiles/340c/maps2.api/main.js"
        },
        {
            id: "gc",
            url: "http://maps.gstatic.com/intl/en_us/mapfiles/340c/gc.js"
        },
        {
            id: "suggest",
            url: "http://maps.gstatic.com/intl/en_us/mapfiles/340c/suggest/main.js"
        },
        {
            id: "pphov",
            url: "http://maps.gstatic.com/intl/en_us/mapfiles/340c/pphov.js"
        }]
    };
    window.GLoad = function(apiCallback) {
        apiCallback(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, jslinker, 0);
    };
    var appOptions = [["http://mt0.google.com/vt/lyrs=m@154\x26hl=en\x26", "http://mt1.google.com/vt/lyrs=m@154\x26hl=en\x26"], ["http://khm0.google.com/kh/v=85\x26", "http://khm1.google.com/kh/v=85\x26"], ["http://mt0.google.com/vt/lyrs=h@154\x26hl=en\x26", "http://mt1.google.com/vt/lyrs=h@154\x26hl=en\x26"], ["http://mt0.google.com/vt/lyrs=t@126,r@154\x26hl=en\x26", "http://mt1.google.com/vt/lyrs=t@126,r@154\x26hl=en\x26"], ["http://khmdb0.google.com/kh?v=38\x26", "http://khmdb1.google.com/kh?v=38\x26"], ["http://mt0.google.com/vt?hl=en\x26", "http://mt1.google.com/vt?hl=en\x26"], , [[, 0, "7", "7", [[[330000000, 1246050000], [386200000, 1293600000]], [[366500000, 1297000000], [386200000, 1320034790]]], ["http://mt0.gmaptiles.co.kr/mt/v=kr1.13\x26hl=en\x26", "http://mt1.gmaptiles.co.kr/mt/v=kr1.13\x26hl=en\x26", "http://mt2.gmaptiles.co.kr/mt/v=kr1.13\x26hl=en\x26", "http://mt3.gmaptiles.co.kr/mt/v=kr1.13\x26hl=en\x26"]], [, 0, "8", "9", [[[330000000, 1246050000], [386200000, 1279600000]], [[345000000, 1279600000], [386200000, 1286700000]], [[348900000, 1286700000], [386200000, 1293600000]], [[354690000, 1293600000], [386200000, 1320034790]]], ["http://mt0.gmaptiles.co.kr/mt/v=kr1.13\x26hl=en\x26", "http://mt1.gmaptiles.co.kr/mt/v=kr1.13\x26hl=en\x26", "http://mt2.gmaptiles.co.kr/mt/v=kr1.13\x26hl=en\x26", "http://mt3.gmaptiles.co.kr/mt/v=kr1.13\x26hl=en\x26"]], [, 0, "10", "19", [[[329890840, 1246055600], [386930130, 1284960940]], [[344646740, 1284960940], [386930130, 1288476560]], [[350277470, 1288476560], [386930130, 1310531620]], [[370277730, 1310531620], [386930130, 1320034790]]], ["http://mt0.gmaptiles.co.kr/mt/v=kr1.13\x26hl=en\x26", "http://mt1.gmaptiles.co.kr/mt/v=kr1.13\x26hl=en\x26", "http://mt2.gmaptiles.co.kr/mt/v=kr1.13\x26hl=en\x26", "http://mt3.gmaptiles.co.kr/mt/v=kr1.13\x26hl=en\x26"]], [, 3, "7", "7", [[[330000000, 1246050000], [386200000, 1293600000]], [[366500000, 1297000000], [386200000, 1320034790]]], ["http://mt0.gmaptiles.co.kr/mt/v=kr1p.12\x26hl=en\x26", "http://mt1.gmaptiles.co.kr/mt/v=kr1p.12\x26hl=en\x26", "http://mt2.gmaptiles.co.kr/mt/v=kr1p.12\x26hl=en\x26", "http://mt3.gmaptiles.co.kr/mt/v=kr1p.12\x26hl=en\x26"]], [, 3, "8", "9", [[[330000000, 1246050000], [386200000, 1279600000]], [[345000000, 1279600000], [386200000, 1286700000]], [[348900000, 1286700000], [386200000, 1293600000]], [[354690000, 1293600000], [386200000, 1320034790]]], ["http://mt0.gmaptiles.co.kr/mt/v=kr1p.12\x26hl=en\x26", "http://mt1.gmaptiles.co.kr/mt/v=kr1p.12\x26hl=en\x26", "http://mt2.gmaptiles.co.kr/mt/v=kr1p.12\x26hl=en\x26", "http://mt3.gmaptiles.co.kr/mt/v=kr1p.12\x26hl=en\x26"]], [, 3, "10", , [[[329890840, 1246055600], [386930130, 1284960940]], [[344646740, 1284960940], [386930130, 1288476560]], [[350277470, 1288476560], [386930130, 1310531620]], [[370277730, 1310531620], [386930130, 1320034790]]], ["http://mt0.gmaptiles.co.kr/mt/v=kr1p.12\x26hl=en\x26", "http://mt1.gmaptiles.co.kr/mt/v=kr1p.12\x26hl=en\x26", "http://mt2.gmaptiles.co.kr/mt/v=kr1p.12\x26hl=en\x26", "http://mt3.gmaptiles.co.kr/mt/v=kr1p.12\x26hl=en\x26"]]], "http://maps.gstatic.com/intl/en_us/mapfiles/340c/maps2", [200524, 200633, 200988, 201003], , , , , , , "Map data \x26#169;2011 ", "Imagery \x26#169;2011 ", "fzwq2qlywm2KP4OlpEuHXbSo4FWF5xgmfx_xDA", [[1415, "."], [1416, ","], [10018, "Loading..."], [10049, "Map"], [10050, "Satellite"], [10111, "Map"], [10112, "Sat"], [10116, "Hybrid"], [10117, "Hyb"], [10120, "We are sorry, but we don't have maps at this zoom level for this region.\x3cp\x3eTry zooming out for a broader look.\x3c/p\x3e"], [10121, "We are sorry, but we don't have imagery at this zoom level for this region.\x3cp\x3eTry zooming out for a broader look.\x3c/p\x3e"], [10177, "Google Maps"], [10511, "Show street map"], [10512, "Show satellite imagery"], [10513, "Show imagery with street names"], [10945, "Add a placemark"], [10946, "Draw a line"], [10947, "Draw a shape"], [10985, "Zoom in"], [10986, "Zoom out"], [11047, "Center map here"], [11133, "http://maps.google.com/support/bin/static.py?page=guide.cs\x26guide=21670\x26topic=21676\x26answer=144365"], [11271, "Directions from here"], [11272, "Directions to here"], [11417, "http://maps.google.com/support/bin/topic.py?topic=12387"], [11631, "http://maps.google.com/support/bin/answer.py?answer=72644"], [11751, "Show street map with terrain"], [11758, "Terrain"], [11759, "Ter"], [12492, "Earth"], [12742, "What's here?"], [12829, "Report a problem"], [13171, "Hybrid 3D"], [13629, "Show 3D imagery"], [13630, "Show 3D imagery with street names"], [13994, "Labels"], [14026, "See geographical and topographical details on the map."], [14045, "Show street, city and boundary names."], [14049, "Not available at this zoom level. Zoom out to use terrain view."], [14050, "Not available in this view. Switch to Map view to use this option."], [14051, "Not available for this location. Try viewing the map for a different location."], [14056, "Not available in this view. Switch to Satellite or Earth view to turn labels on or off."], [14100, "Explore more of your city from 45 degree angle."], [14105, "Not available in this location. Zoom in to see 45 degree imagery."], [14106, "Not available in map view. Switch to Satellite to see 45 degree imagery."]], "4dd30efdZ2zu2Am-Th4J8Po4IZADdkv7Tas", , [["http://mt0.google.com/mapstt", "http://mt1.google.com/mapstt", "http://mt2.google.com/mapstt", "http://mt3.google.com/mapstt"], ["msid:103669521412303283270.000470c7965f9af525967", "msid:111496436295867409379.00047329600bf6daab897"]], "http://mt0.google.com/vt/pt", [["http://mt0.google.com/mapslt", "http://mt1.google.com/mapslt", "http://mt2.google.com/mapslt", "http://mt3.google.com/mapslt"], "http://mt0.google.com/vt/ft", "1305677565180"], [["12102", "com.panoramio.all", , 280, , , , , , , ["layers.panoramio", "http://maps.gstatic.com/intl/en_us/mapfiles/ftr/layers/panoramio.5.js"], 1, , "14030", -60, 0, "mv-hc-photos"], ["12103", "com.youtube.all", , 150, , , , , , , ["layers.youtube", "http://maps.gstatic.com/intl/en_us/mapfiles/ftr/layers/youtube.0.js"], 1, , "14029", -160, 0, "mv-hc-video"], ["12210", "org.wikipedia.en", , 140, , , , , , , , 1, , "14099", -220, 0, "mv-hc-wiki"], ["12953", "com.google.webcams", , 160, , , , , , , ["layers.webcams", "http://maps.gstatic.com/intl/en_us/mapfiles/ftr/layers/webcams.0.js"], , , "14103", -200, 0, "mv-hc-webcam"], ["13606", "com.google.latitudepublicupdates", , 120, , , , , , , , , 1, "14102", -20, 0, "mv-hc-buzz"]], "http://www.google.com/mapprint", , , [1, 1, "https://maps-api-ssl.google.com/maps/suggest", "http://www.google.com/history/", 2000, 0, 0, "http://maps.google.com/support/bin/answer.py?answer=173398\x26hl=en", 0, 1000, 1000, , 5, 5, 2, 0, , "", 0], [1, "maps"], , , , , 1, , 1, [0, 0], , , "/reviews/scripts/annotations_bootstrap.js?hl=en\x26gl=us", 42, 1, 1, 1, 0, "http://maps.google.com/local_url?q=http://www.adobe.com/shockwave/download/download.cgi%3FP1_Prod_Version%3DShockwaveFlash\x26dq=http://data.octo.dc.gov/Gateway_2011051611594.ashx%3Fname%3Dhttp://data.octo.dc.gov/feeds/src/src_current.kml\x26s=ANYYN7manSNIV_th6k0SFvGB4jz36is1Gg", 0, 0, 0, 0, 0, 0, 0, 1, 0, "\x26#169;2011 Google", "http://www.google.com/intl/en_us/help/terms_maps.html", , "en", "us", "google.com", [["m", 1, , , , , , , , , , , , , , 0, , , , , , , , , [941, 650], [1322, 775]], []], 1, 1, 0, "4dd30efdrq02CcBC", "", "113350876865363961667", "http://maps.gstatic.com/intl/en_us/mapfiles/", "/intl/en_us/mapfiles/", "340c", 0, , 1, 1, 1, 1, 1, 1, , , "http://cbk0.google.com", 1, 20, 4096, , , , , , , , ["drag", "scrwh", "mv"], ["lt_c", "pplhs", "lcs_c", "stats"], [38.912376, -77.002426], , 1001, 1, "maps_sv", 3, , , 1, 0, , "http://gg.google.com/csi", 0, "geoobject@gmail.com", "", 0];
    if (window.gAppCacheManager && window.gAppCacheManager.loadedFromCache()) {
        appOptions[33] = 1;
    }
    window.GLoadMapsScript = function() {
        if (!GLoadMapsScript.called && GBrowserIsCompatible()) {
            GLoadMapsScript.called = true;
            tick("d");
            var msu = appOptions[33] ? "http://maps.gstatic.com/intl/en_us/mapfiles/340c/maps2/app.js": "http://maps.gstatic.com/intl/en_us/mapfiles/340c/maps2/main.js";
            GScript(msu);
        }
    };
    window.GLoad2 = function(apiCallback) {
        var callee = arguments.callee;
        if (!callee.called) {
            tick('e');
        }
        apiCallback(appOptions, jslinker);
        if (!callee.called) {
            callee.called = true;
            tick('f');
            jsLoadCallback(appOptions);
        }
    }
})();
function GUnload() {
    if (window.GUnloadApi) {
        GUnloadApi();
    }
}
var _mF = [, , , 100, false, "ar,iw", "", 500, "http://chart.apis.google.com/chart?cht\x3dqr\x26chs\x3d80x80\x26chld\x3d|0\x26chl\x3d", true, true, 10, 30, false, "AT,AU,BE,BH,BR,CA,CH,CN,CZ,DE,DK,DZ,FI,FR,GB,HK,HU,IE,IN,IQ,IT,KR,KW,LY,MA,MX,MY,NL,NO,NZ,OM,PL,PR,PT,QA,RU,SE,SG,TH,TN,TW,US,YE", "AT,AU,BE,BH,BR,CA,CH,CN,CZ,DE,DK,DZ,FI,FR,GB,HK,HU,IE,IN,IQ,IT,KR,KW,LY,MA,MX,MY,NL,NO,NZ,OM,PL,PR,PT,QA,RU,SE,SG,TH,TN,TW,US,YE", "windows-ie,windows-firefox,windows-chrome,macos-safari,macos-firefox,macos-chrome", false, false, "", true, 0.25, 8, false, false, , false, false, false, false, "DE,CH,LI,AT,BE,PL,NL,HU,GR,HR,CZ,SK,TR,BR,EE,ES,AD,SE,NO,DK,FI,IT,VA,SM,IL,CL,MX,AR,BG,PT", "25", true, , false, "", , false, , '', 24, 6, 2, 0, "/maps/c/u/0", , 3, 5, "windows-firefox,windows-ie,windows-chrome,macos-firefox,macos-safari,macos-chrome", false, false, false, true, false, 600, true, false, true, true, true, false, false, , "/maps/c/ui/HovercardLauncher/dommanifest.js", "107485602240773805043.00043dadc95ca3874f1fa", false, 45, , "http://chart.apis.google.com/chart", true, , 25, true, "1.x", false, false, false, true, , true, false, false, true, 10000, 10, 8, true, true, true, false, false, true, , , , "2", 18, false, "http://www.google.com/maps/photos", true, , true, false, , , , false, , true, true, 1.4, , false, true, false, false, , false, false, 0, , false, false, false, false, false, true, true, true, , false, false, false, false, false, false, true, false, , false, false, false];
var _mHL = "en";
var _mIsRtl = false;actionData('jsv', '340c'); (function() {
    window.gHomeVPage = {
        title: 'http://data.octo.dc.gov/Gateway_2011051611594.ashx?name\x3dhttp://data.octo.dc.gov/feeds/src/src_current.kml - Google Maps',
        url: '/?q\x3dhttp://data.octo.dc.gov/Gateway_2011051611594.ashx%3Fname%3Dhttp://data.octo.dc.gov/feeds/src/src_current.kml\x26ie\x3dUTF8',
        urlViewport: false,
        ei: '_Q7TTa32CZT-zQTL8JXUBQ',
        form: {
            selected: 'q',
            q: {
                q: 'http://data.octo.dc.gov/Gateway_2011051611594.ashx?name\x3dhttp://data.octo.dc.gov/feeds/src/src_current.kml',
                what: 'http://data.octo.dc.gov/Gateway_2011051611594.ashx?name\x3dhttp://data.octo.dc.gov/feeds/src/src_current.kml',
                near: ''
            },
            d: {
                saddr: '',
                daddr: ''
            },
            geocode: ''
        },
        viewport: {
            center: {
                lat: 38.912378,
                lng: -77.002424
            },
            span: {
                lat: 3e-06,
                lng: 3e-06
            },
            zoom: 19,
            mapType: 'm'
        },
        modules: ['', 'kml', 'appiw'],
        overlays: {
            sxcar: false,
            layers: [{
                composition_type: 2,
                spec: {
                    id: 'm'
                },
                default_epoch: 154,
                pertile_data: {
                    area: [{
                        id: 'twutvttwuuwvwvwuttvtt',
                        zrange: [21, 21],
                        layer: 'm',
                        epoch: 154016045
                    },
                    {
                        id: 'twutvttwuuwvwvwuttvttt',
                        zrange: [22, 22],
                        layer: 'm',
                        epoch: 154016045
                    }]
                }
            }]
        },
        kmlOverlay: {
            tileUrlBase: '',
            force_mapsdt: false,
            geViewable: true,
            name: 'Contents',
            description: 'Only records with coordinates can be shown here.  Records that currently have no coordinates in the source record are not shown on the map.',
            markers: [{
                id: 'A',
                fid: 'g3c3790e2fb6ac512',
                latlng: {
                    lat: 38.912379,
                    lng: -77.002423
                },
                image: 'http://maps.google.com/mapfiles/kml/pushpin/ylw-pushpin_maps.png',
                ext: {
                    width: 32,
                    height: 32,
                    shadow: 'http://maps.google.com/mapfiles/kml/pushpin/blue-pushpin_maps.shadow.png',
                    shadow_width: 59,
                    shadow_height: 32,
                    mask: false,
                    hotspot_x: 0.5,
                    hotspot_y: 1,
                    hotspot_x_units: 1,
                    hotspot_y_units: 1
                },
                drg: false,
                laddr: 'Bulk Collection, 2010-11-12 @38.912379,-77.002423',
                geocode: '',
                sxti: 'Bulk Collection, 2010-11-12',
                name: 'Bulk Collection, 2010-11-12',
                description: '235 R STREET NE\x3cbr\x3e\x3cbr\x3eBulk Collection\x3cbr\x3e\x3cbr\x3eResponsible Agency: DPW\x3cbr\x3eStatus: OVERDUE CLOSED\x3cbr\x3eResolution: UNKNOWN\x3cbr\x3e',
                infoWindow: {
                    title: 'Bulk Collection, 2010-11-12',
                    basics: '\x3cdiv transclude\x3d\x22iw\x22\x3e\x3c/div\x3e',
                    snippet: '235 R STREET NEBulk CollectionResponsible Agency: DPWStatus: OVERDUE CLOSEDResol',
                    dscr: '235 R STREET NE\x3cbr\x3e\x3cbr\x3eBulk Collection\x3cbr\x3e\x3cbr\x3eResponsible Agency: DPW\x3cbr\x3eStatus: OVERDUE CLOSED\x3cbr\x3eResolution: UNKNOWN\x3cbr\x3e',
                    dscr_dir: 'ltr',
                    photoUrl: 'http://cbk0.google.com/cbk?output\x3dthumbnail\x26w\x3d90\x26h\x3d68\x26ll\x3d38.912379,-77.002423\x26thumb\x3d0',
                    photoType: 2
                },
                ss: {
                    edit: false,
                    detailseditable: false,
                    deleted: false,
                    rapenabled: false,
                    mmenabled: false
                },
                b_s: 0,
                elms: [6, 10, 1, 12, 1, 9, 2, 5]
            }],
            layer_id: 'kml:cu9BkDld3vYZD5mRuc40BIorCDEwtRWkv3cL1wIUNp-BMyO9Ckzlc3fUaDpmT-6WsE8zoBDNFbhaYjZEA',
            server_version: 3,
            server_options: 'sY'
        },
        panelId: 1000,
        show_overview_map: false,
        is_details_req: false,
        dopts: {
            dtm: 'd',
            atms: ['d', 'r', 'w', 'b'],
            ddu: 'm',
            transit: {
                hts: true,
                tmos: ['now', 'dep', 'arr'],
                tm: {
                    d: 'dep'
                },
                date: {},
                time: {},
                sos: ['def', 'num', 'walk'],
                st: {
                    d: 'def'
                },
                ne: {
                    h: true
                },
                na: {
                    h: true
                }
            }
        },
        slayers_trigger: false,
        timeformat: {
            ampm: true,
            dp: 'mdy'
        },
        activityType: 5,
        page_conf: {
            topbar_config: {
                show_panel_toggler: true,
                directions_url: 'javascript:void(0)',
                mymaps_url: 'javascript:void(0)',
                show_directions_link: true,
                show_my_places_link: false,
                my_places_url: 'javascript:void(0)'
            },
            panel_display: true
        }
    };
})();gHomeVPage.panel = e("panel" + gHomeVPage.panelId).innerHTML;vpLoadHome.arg(0, gHomeVPage);vpLoadHome.func(function(vpage, stateBox) {
    vpLoad.arg(1, vpage).arg(2, stateBox).arg(4, true).check();
}).check(); (function() {
    var num_zoom_slider_levels = 19;
    window.constructGappParams = function(vPage, stateBox, isHomeVPage) {
        return {
            vp: vPage,
            sb: stateBox,
            ho: isHomeVPage,
            izsnzl: num_zoom_slider_levels + extraZoomLevel,
            eq: gEventQueue,
            elog: gErrorLogger,
            glp: window.gGeolocationPosition
        };
    };
})();
function loadApplication(vPage, stateBox, appOptions, isHomeVPage) {
    gapp(document, appOptions, constructGappParams(vPage, stateBox, isHomeVPage));


    gEventQueue = null;
}
var oljiBarrier = new B(2);oljiBarrier.func(function() {
    tick('olji');
});
function onLoadHideLoadMessage() {
    if (gIsHomeVPage) {
        tick('pxd');
    }
    if (!window.gUserAction) {
        e('loadmessagehtml').style.display = 'none';
        tick('hlm');
    }
}
function onLoadMainJs() {
    GLoadMapsScript();
}
function onLoadApplicationInitialize() {
    vpLoad.arg(0, 'aiol').check();
} (function() {
    var show_inline_markers = false;
    window.onLoad = function() {
        tick('ol');
        if (show_inline_markers) {
            tick('mkr1');
        }
        oljiBarrier.arg(0, true).check();
        onLoadHideLoadMessage();
        onLoadMainJs();
        onLoadApplicationInitialize();
        done();
    };
})(); (function() {
    var inline_value = 1;
    var is_ie = false;
    function resetT() {
        try {
            if (is_ie) {
                window.external.resT();
            } else {
                window.external.resT && window.external.resT();
            }
        } catch(e) {}
    }
    vpLoad.func(function(sourceTick, vPage, stateBox, appOptions, isHomeVPage) {
        vpLoad.func(null);
        tick(sourceTick);
        if (isHomeVPage) {
            actionData('fvp', 1);
            actionData('inl', inline_value);
        } else {
            actionData('inl', 0);
            actionData('fvp', 0);
        }
        resetT();
        loadApplication(vPage, stateBox, appOptions, isHomeVPage);
        oljiBarrier.arg(1, true).check();
    }).check();
    branch();
    window.onload = onLoad;
})();

var userActions = [
'mousedown', 'keydown', 'mousewheel',
'DOMMouseScroll'
];
var gUserAction = false;
function firstActionLoadMessages() {
    e('loadmessagehtml').style.display = '';
    if (e('slowmessage') && e('slowmessage').style.display != 'none') {
        reportSlowLoadingMessage();
    }
}
function firstActionLoadApplication() {
    setTimeout(function() {
        GLoadMapsScript();
        vpLoad.arg(0, 'aiua').check();
    },
    0);
}
function onFirstUserAction(event) {
    function closestParentId(node) {
        if (!node) return 'none';
        if (node.id) {
            return node.id;
        } else if (node.parentNode) {
            return closestParentId(node.parentNode);
        } else {
            return 'none';
        }
    }
    tick('ua');
    var id = 'none';
    if (event.target) {
        id = closestParentId(event.target);
    } else if (event.srcElement) {
        id = closestParentId(event.srcElement);
    }
    var firstUserAction = event.type + '-' + id;
    actionData('fua', firstUserAction);
    for (var i = 0; i < userActions.length; ++i) {
        removeDocListener(userActions[i], onFirstUserAction);
    }
    if (gUserAction) return;
    gUserAction = true;
    firstActionLoadMessages();
    firstActionLoadApplication();
}
for (var i = 0; i < userActions.length; ++i) {
    addDocListener(userActions[i], onFirstUserAction);
}
 (function() {
    var cityblock_enabled = true;
    if (navigator.geolocation) {
        var inline_compass_size = 90;
        var zoomTop = 29 + inline_compass_size;
        var zoomHeight = 377;
        e('flmc_inline').style.height = '' + zoomHeight + 'px';
        e('flmczoom_inline').style.top = '' + zoomTop + 'px';
        if (cityblock_enabled) {
            var cbTop = 26 + inline_compass_size;
            var cbTopPx = '' + cbTop + 'px';
            e('cb_inl_launchpad').style.top = cbTopPx;
            var pegman = e('pegman_inline');
            if (pegman) {
                pegman.style.top = cbTopPx;
            }
        }
        d1('my_location_button');
    }
})();tick('fs1');