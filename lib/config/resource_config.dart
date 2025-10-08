class ResourceConfig {
  static const int cacheTime = 7200;
  
  static final Map<String, ResourceSite> sites = {
    'dyttzy': ResourceSite(
      name: '电影天堂资源',
      api: 'http://caiji.dyttzyapi.com/api.php/provide/vod',
      detail: 'http://caiji.dyttzyapi.com',
    ),
    'ruyi': ResourceSite(
      name: '如意资源',
      api: 'http://cj.rycjapi.com/api.php/provide/vod',
    ),
    'tyyszy': ResourceSite(
      name: '天涯资源',
      api: 'https://tyyszy.com/api.php/provide/vod',
    ),
    'ffzy': ResourceSite(
      name: '非凡影视',
      api: 'http://ffzy5.tv/api.php/provide/vod',
      detail: 'http://ffzy5.tv',
    ),
    'zy360': ResourceSite(
      name: '360资源',
      api: 'https://360zy.com/api.php/provide/vod',
    ),
    'maotaizy': ResourceSite(
      name: '茅台资源',
      api: 'https://caiji.maotaizy.cc/api.php/provide/vod',
    ),
    'jisu': ResourceSite(
      name: '极速资源',
      api: 'https://jszyapi.com/api.php/provide/vod',
      detail: 'https://jszyapi.com',
    ),
    'dbzy': ResourceSite(
      name: '豆瓣资源',
      api: 'https://dbzy.tv/api.php/provide/vod',
    ),
    'mozhua': ResourceSite(
      name: '魔爪资源',
      api: 'https://mozhuazy.com/api.php/provide/vod',
    ),
    'yinghua': ResourceSite(
      name: '樱花资源',
      api: 'https://m3u8.apiyhzy.com/api.php/provide/vod',
    ),
    'lzi': ResourceSite(
      name: '量子资源站',
      api: 'https://cj.lziapi.com/api.php/provide/vod',
    ),
  };
}

class ResourceSite {
  final String name;
  final String api;
  final String? detail;

  ResourceSite({
    required this.name,
    required this.api,
    this.detail,
  });
}