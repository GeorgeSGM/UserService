# Базовый образ
FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build

# Копирование и сборка проектов
WORKDIR /app

# Копирование и восстановление зависимостей для каждого проекта
COPY UserService.sln .
COPY UserService.Domain ./UserService.Domain
COPY UserService.Host ./UserService.Host
COPY UserService.Infrastructure ./UserService.Infrastructure
RUN dotnet restore

# Сборка проектов
RUN dotnet build

# Копирование и публикация проектов
COPY UserService.Domain ./UserService.Domain
COPY UserService.Host ./UserService.Host
COPY UserService.Infrastructure ./UserService.Infrastructure
RUN dotnet publish -c Release -o out

# Конечный образ
FROM mcr.microsoft.com/dotnet/aspnet:5.0 AS final
WORKDIR /app
COPY --from=build /app/UserService.Host/out .
ENTRYPOINT ["dotnet", "UserService.Host.dll"]