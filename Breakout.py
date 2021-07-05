import pygame


FPS = 60

# define colors
BLACK = (0, 0, 0)
RED = (255, 0, 0)
GREEN = (0, 255, 0)
BLUE = (0, 0, 255)
YELLOW = (255, 255, 0)
CYAN = (0, 255, 255)
MAGENTA = (255, 0, 255)
GRAY = (127, 127, 127)
WHITE = (255, 255, 255)
WIDTH = 640
HEIGHT = 800



pygame.init()
pygame.mixer.init()
screen = pygame.display.set_mode((WIDTH, HEIGHT))
pygame.display.set_caption("Breakout! by CJ")
clock = pygame.time.Clock()
color_list = [RED, GREEN, YELLOW, BLUE, CYAN, MAGENTA]
brick_width = screen.get_width() / 16
brick_height = 15

class Paddle(pygame.sprite.Sprite):
    def __init__(self):
        pygame.sprite.Sprite.__init__(self)
        self.image = pygame.Surface((100, 20))
        self.image.fill(GREEN)
        self.rect = self.image.get_rect()
        self.rect.centerx = WIDTH / 2
        self.rect.bottom = HEIGHT - 100
        self.speedx = 0

    def update(self):
        self.speedx = 0
        keystate = pygame.key.get_pressed()
        if keystate[pygame.K_LEFT]:
            self.speedx = -10
        if keystate[pygame.K_RIGHT]:
            self.speedx = 10
        self.rect.x += self.speedx
        if self.rect.right > WIDTH:
            self.rect.right = WIDTH
        if self.rect.left < 0:
            self.rect.left = 0

    def shoot(self):
        ball.rect.centerx = WIDTH / 2
        ball.rect.centery = HEIGHT / 2
        vel = [3, -3]
        ball.move(vel)
        all_sprites.update()


class Brick(pygame.sprite.Sprite):
    def __init__(self, color):
        pygame.sprite.Sprite.__init__(self)
        self.image = pygame.Surface((WIDTH / 16, 15), 1)
        self.image.fill(color)
        self.rect = self.image.get_rect()
        self.rect.x = 0
        self.rect.y = 0 
        # pygame.draw.rect(screen, WHITE, self.rect, 1)


class Bullet(pygame.sprite.Sprite):
    def __init__(self):
        pygame.sprite.Sprite.__init__(self)
        self.image = pygame.Surface((10, 10))
        self.image.fill(RED)
        self.rect = self.image.get_rect()
        self.rect.x = WIDTH / 2
        self.rect.y = HEIGHT / 2
        self.rect.centerx = WIDTH / 2
    
    def move(self, dir):
        self.rect.move_ip(dir)
        if self.rect.left < 0:
            dir[0] *= -1
        if self.rect.right > WIDTH:
            dir[0] *= -1
        if self.rect.top < 0:
            dir[1] *= -1
        if self.rect.bottom > HEIGHT:
            dir[0] = 0
            dir[1] = 0
        
        


all_sprites = pygame.sprite.Group()
the_bricks = pygame.sprite.Group()
ball = Bullet()
all_sprites.add(ball)
paddle = Paddle()
all_sprites.add(paddle)

for y_pos in range(6):
    my_color = color_list[y_pos]
    for x_pos in range(16):
        b = Brick(my_color)
        b.rect.x = x_pos * brick_width
        b.rect.y = y_pos * brick_height
        all_sprites.add(b)
        the_bricks.add(b)

total_score = 0

running = True
vel = [3, -3]
while running:
    clock.tick(FPS)

    for event in pygame.event.get():
        # check for closing window
        if event.type == pygame.QUIT:
            running = False
        elif event.type == pygame.KEYDOWN:
            if event.key == pygame.K_SPACE:
                paddle.shoot()
    
    screen.fill(BLACK)
    
    font = pygame.font.SysFont(None, 48)
    if total_score == 960:
        img = font.render("YOU WON!", True, BLUE)
    else:
        img = font.render(str(total_score), True, BLUE)

    screen.blit(img, (screen.get_width() / 2, screen.get_height() / 2))

    # Update
    all_sprites.update()

    ball.move(vel)
    

    hits = pygame.sprite.spritecollide(ball, the_bricks, True)
    for hit in hits:
        b = Brick(BLACK)
        vel[1] *= -1
        b.kill()
        total_score = total_score + 10
    
    if ball.rect.colliderect(paddle.rect):
        vel[1] *= -1


    # Draw / render
    all_sprites.draw(screen)
    # *after* drawing everything, flip the display
    pygame.display.flip()

pygame.quit()