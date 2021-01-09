from django.shortcuts import render, HttpResponse

# Create your views here.

def blogHome(request):
	return HttpResponse("hello bloghome here we post all blogs")



def blogPost(request, slug):
	return HttpResponse(f'hello blogPost: {slug}')
