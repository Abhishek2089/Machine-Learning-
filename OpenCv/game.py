import pygame

pygame.init()

#colors
white =(255, 255, 255) 
red = (255, 0, 0)
black = (0, 0, 0)

screen_height = 1200;
screen_width = 600;

gameWindow = pygame.display.set_mode((screen_height, screen_width))


pygame.display.set_caption("snake")
pygame.display.update()


#game loops
exit_game = False
game_over = False

while not exit_game:
	for event in pygame.event.get():
		print(event)
		if event.type == pygame.QUIT:
			exit_game = True


		gameWindow.fill(white)
		pygame.display.update()

	pygame.draw.rect(gameWindow, (0, 125, 255), pygame.Rect(30, 30, 60, 60))
	pygame.display.flip()

pygame.quit()
quit()