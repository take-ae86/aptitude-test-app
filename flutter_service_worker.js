'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"canvaskit/chromium/canvaskit.js": "5e27aae346eee469027c80af0751d53d",
"canvaskit/chromium/canvaskit.js.symbols": "193deaca1a1424049326d4a91ad1d88d",
"canvaskit/chromium/canvaskit.wasm": "24c77e750a7fa6d474198905249ff506",
"canvaskit/canvaskit.js": "140ccb7d34d0a55065fbd422b843add6",
"canvaskit/canvaskit.js.symbols": "58832fbed59e00d2190aa295c4d70360",
"canvaskit/canvaskit.wasm": "07b9f5853202304d3b0749d9306573cc",
"canvaskit/skwasm.js": "1ef3ea3a0fec4569e5d531da25f34095",
"canvaskit/skwasm.js.symbols": "0088242d10d7e7d6d2649d1fe1bda7c1",
"canvaskit/skwasm.wasm": "264db41426307cfc7fa44b95a7772109",
"canvaskit/skwasm_heavy.js": "413f5b2b2d9345f37de148e2544f584f",
"canvaskit/skwasm_heavy.js.symbols": "3c01ec03b5de6d62c34e17014d1decd3",
"canvaskit/skwasm_heavy.wasm": "8034ad26ba2485dab2fd49bdd786837b",
"flutter.js": "888483df48293866f9f41d3d9274a779",
"flutter_bootstrap.js": "7a02c95d3363718a062d097beb163832",
"index.html": "2666cd97b9c1dfd57c798b2317a15ed2",
"/": "2666cd97b9c1dfd57c798b2317a15ed2",
"main.dart.js": "29cc1486aaeda91f2c77f29ef4c7e08b",
"version.json": "7fd21c1884405f6d4c017aa8298e467f",
"assets/assets/cab/law/law_exp_01.png": "08ea03db05af9d55f00af2e5acef7279",
"assets/assets/cab/law/law_exp_01_1.png": "3a95fee256152523904344ecb76fcaa5",
"assets/assets/cab/law/law_exp_01_2.png": "974b69153c05faf2ddbadfcd01370236",
"assets/assets/cab/law/law_exp_02.png": "11ffe8df2ada282a6b7091a3c1cc2908",
"assets/assets/cab/law/law_exp_03.png": "0f86300626691547a53d3303b807c1f2",
"assets/assets/cab/law/law_exp_04.png": "a94eb99e80032b228a149ded87b064b4",
"assets/assets/cab/law/law_exp_05.png": "7b6e4563b1d77a5309d8ab118fb878ab",
"assets/assets/cab/law/law_exp_06.png": "54f8884437016872690a8564b0cb0443",
"assets/assets/cab/law/law_opt_01.png": "22c279c1ed05e3501995f3f918a9279c",
"assets/assets/cab/law/law_opt_02.png": "5906c213f8e13fec432f9e5285383392",
"assets/assets/cab/law/law_opt_03.png": "03bbbda42fd1c064123e1976010ff483",
"assets/assets/cab/law/law_opt_04.png": "2dcccaabb0e9b351bafec5394b796ce1",
"assets/assets/cab/law/law_opt_05.png": "a033c6b9127eac42c544b5edf9087b31",
"assets/assets/cab/law/law_opt_06.png": "ea2ac5673813b1b13d1e2d6f871ab0cd",
"assets/assets/cab/law/law_q_01.png": "4fd5ca374eac0f7c6d1aaad436e61717",
"assets/assets/cab/law/law_q_02.png": "407e062f68d29d5b1166333a99c332b8",
"assets/assets/cab/law/law_q_03.png": "a4d483b02c4da03ba2efc8082d2866c3",
"assets/assets/cab/law/law_q_04.png": "5e1bafc3bcd09395afdc6f603185e76d",
"assets/assets/cab/law/law_q_05.png": "79bc8a9263e9bc59b00b9f7353232108",
"assets/assets/cab/law/law_q_06.png": "7a40a18bd607ead6f2cec99ae3702b03",
"assets/assets/cab/law/new_img01_p0_options.png": "cf21ee42e647e5b0b9f177347f305731",
"assets/assets/cab/law/new_img01_p0_question.png": "d90d43abc9ad03a371f842fb2ecb0cf3",
"assets/assets/cab/law/new_img01_p1_options.png": "c926852ceec1ad85b51d9b82bdddae10",
"assets/assets/cab/law/new_img01_p1_question.png": "062c5b62194156519f873a79575d6140",
"assets/assets/cab/law/new_img02_p0_options.png": "a1b73b773488468894214b396a21147d",
"assets/assets/cab/law/new_img02_p0_question.png": "c4ac6935e38d5c3c3a7578affec30b23",
"assets/assets/cab/law/new_img02_p1_options.png": "4ba1b40e6280e424e3ec45bf6cb76537",
"assets/assets/cab/law/new_img02_p1_question.png": "096e7aaf7bc96bf445bfe806eabfdab0",
"assets/assets/cab/law/new_img03_p0_options.png": "5ffd66196ee1f6c538cb0ee3d3c95fd9",
"assets/assets/cab/law/new_img03_p0_question.png": "a6d4b87234fd1ca42346a9855374cf3e",
"assets/assets/cab/law/new_img03_p1_options.png": "32ff71f0e463db2dcd6ad0526ba01b72",
"assets/assets/cab/law/new_img03_p1_question.png": "b3041858ca42f59cee0cc7f65658b36e",
"assets/assets/cab/law/new_img04_p0_options.png": "a3531ecbda335a67b67a83e79d7ec09b",
"assets/assets/cab/law/new_img04_p0_question.png": "09d346c7629391ac9379905331b8b5d7",
"assets/assets/cab/law/new_img04_p1_options.png": "cf1b19b61b8e0c77ca33b7077b7b9d6f",
"assets/assets/cab/law/new_img04_p1_question.png": "f29ce896b29f7eaee1d17371ae6b482b",
"assets/assets/cab/law/new_img05_p0_options.png": "8008907bba1c7f886e90c5f1205fc48e",
"assets/assets/cab/law/new_img05_p0_question.png": "ad5964ce8e3dc7569c3cc9603c2629e6",
"assets/assets/cab/law/new_img05_p1_options.png": "033a70ddc7882819670f13a5c0d34665",
"assets/assets/cab/law/new_img05_p1_question.png": "e45e8fef61dc07790d74d42e13239524",
"assets/assets/cab/law/new_img06_p0_options.png": "d515fada8ec40817d2192fb90409ebdd",
"assets/assets/cab/law/new_img06_p0_question.png": "4973ee62f20c249916a7239cdcb33ac5",
"assets/assets/cab/law/new_img06_p1_options.png": "f906386474bb03d307be50900c70e48f",
"assets/assets/cab/law/new_img06_p1_question.png": "ccf2833be09ac7cb407cd7418e398c9b",
"assets/assets/cab/law/new_img07_p0_options.png": "6d503346109263ddb4f19e47ae8ba869",
"assets/assets/cab/law/new_img07_p0_question.png": "dd3dc83650ad5b5eb99ff6041432c925",
"assets/assets/cab/law/new_img07_p1_options.png": "2c902f8df40ea1750c3787ed7308bbb2",
"assets/assets/cab/law/new_img07_p1_question.png": "4eeeba71b18e05e6640eacf9d30a448a",
"assets/assets/logo.png": "d81e1e1d399565869adadbb779baa262",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "33b7d9392238c04c131b6ce224e13711",
"assets/fonts/MaterialIcons-Regular.otf": "5ea84872b0e7d188d881b12df2c86dc6",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.json": "4897c84ff1cf7cbba21c280eb71c97f0",
"assets/AssetManifest.bin": "9c1446e6f1d1f9d4678627a18f75764d",
"assets/AssetManifest.bin.json": "cd470044592a6c58cd965ec3f77564fa",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/NOTICES": "f092896a1b3d9597c02b23e9e3beccef",
"favicon.png": "875cddc0597f5a409322de17d53e596e",
"icons/Icon-192.png": "1879f686ec890345d4da37444477f344",
"icons/Icon-512.png": "d81e1e1d399565869adadbb779baa262",
"icons/Icon-maskable-192.png": "1879f686ec890345d4da37444477f344",
"icons/Icon-maskable-512.png": "d81e1e1d399565869adadbb779baa262",
"manifest.json": "48da9ef8abb8322571dfc1a67e893986"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
