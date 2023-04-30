from django.views import View
from django.contrib.staticfiles.views import serve
from django.http import HttpResponseNotFound, FileResponse
from django.conf import settings
from django.utils.decorators import method_decorator
from django.views.decorators.cache import cache_control

class StaticView(View):
    
    @method_decorator(cache_control(public=True, max_age=settings.STATIC_CACHE_TIME))
    def get(self, request):
        filepath = str(settings.BASE_DIR) + request.path
        if ".." in request.path:
            return HttpResponseNotFound()
        
        print(f"STATIC FILE: {filepath}")
        file = open(filepath, "rb")
        return FileResponse(file, as_attachment=False)
